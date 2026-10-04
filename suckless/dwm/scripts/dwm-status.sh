#!/usr/bin/env bash
# Compact, live X11 status line for the charcoal dwm bar.

# Decode Unicode icon escapes even when the session locale is unavailable.
export LC_ALL=C.UTF-8

proc_root=/proc
sys_root=/sys
weather_url='https://api.open-meteo.com/v1/forecast?latitude=23.8103&longitude=90.4125&current=temperature_2m,weather_code,is_day&temperature_unit=celsius&timezone=Asia%2FDhaka&forecast_days=1'
network_previous_interface=
weather_pid=
weather_dir=
cpu_icon=$'\uf2db'
memory_icon=$'\uefc5'
usage_icon=$'\uf303'
# gpu_icon=$''


gpu_usage() {
	local gpu_usage
	gpu=$(timeout 2 nvidia-smi -i 0 --query-gpu=utilization.gpu \
		--format=csv,noheader,nounits 2>/dev/null)
	printf '\U000f08ae %s%%' "${gpu:-?}"
}

cpu_sample() {
    local label user nice system idle iowait irq softirq steal rest
    read -r label user nice system idle iowait irq softirq steal rest < "$proc_root/stat"
    cpu_total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    cpu_idle=$((idle + iowait))
}

temperature() {
    local sensor name entry value
    for sensor in "$sys_root"/class/hwmon/hwmon*; do
        read -r name 2>/dev/null < "$sensor/name" || continue
        [[ $name == k10temp || $name == coretemp ]] || continue
        for entry in "$sensor"/temp*_input; do
            read -r value 2>/dev/null < "$entry" || continue
            [[ $value =~ ^-?[0-9]+$ ]] || continue
            if ((value < 0)); then value=$((value - 999)); fi
            printf '%s°C' "$((value / 1000))"
            return
        done
    done
    printf '%s' '--°C'
}

memory() {
    LC_ALL=C awk '
        $1 == "MemTotal:" { total = $2 }
        $1 == "MemAvailable:" { available = $2 }
        END { printf "%.2fg", (total - available) / 1048576 }
    ' "$proc_root/meminfo"
}

recording() {
    local process name arg
    local -a args
    for process in "$proc_root"/[0-9]*; do
        args=()
        mapfile -d '' -t args 2>/dev/null < "$process/cmdline" || continue
        ((${#args[@]})) || continue
        name=${args[0]##*/}
        case $name in
            wf-recorder|gpu-screen-recorder) printf 'Rec ●'; return ;;
            ffmpeg)
                for arg in "${args[@]}"; do
                    if [[ $arg == x11grab || $arg == kmsgrab ]]; then
                        printf 'Rec ●'
                        return
                    fi
                done
                ;;
        esac
    done
    printf 'Rec ·'
}

volume() {
    local output
    output=$(timeout 2 wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null) || return 0
    [[ -n $output ]] || return 0
    if [[ $output == *'[MUTED]'* ]]; then
        printf '\ueee8 muted'
    else
        LC_ALL=C awk -v icon=$'\uf028' '
            $2 ~ /^[0-9]+([.][0-9]+)?$/ { printf "%s %.0f%%", icon, $2 * 100 }
        ' <<< "$output"
    fi
}

battery() {
    local device capacity
    for device in "$sys_root"/class/power_supply/BAT*; do
        read -r capacity 2>/dev/null < "$device/capacity" || continue
        printf '\uf240 %s%%' "$capacity"
        return
    done
}

network_interface() {
    local interface destination gateway flags ref use metric rest device state
    local best_interface= best_metric=
    if [[ -r $proc_root/net/route ]]; then
        while read -r interface destination gateway flags ref use metric rest; do
            [[ $destination == 00000000 && $flags =~ ^[0-9a-fA-F]+$ && $metric =~ ^[0-9]+$ ]] || continue
            (( (16#$flags & 1) != 0 )) || continue
            if [[ -z $best_metric ]] || ((10#$metric < best_metric)); then
                best_interface=$interface
                best_metric=$((10#$metric))
            fi
        done < "$proc_root/net/route"
    fi
    if [[ -n $best_interface ]]; then
        printf '%s' "$best_interface"
        return
    fi
    for device in "$sys_root"/class/net/*; do
        [[ ${device##*/} != lo ]] || continue
        read -r state 2>/dev/null < "$device/operstate" || continue
        if [[ $state == up ]]; then
            printf '%s' "${device##*/}"
            return
        fi
    done
}

network_sample() {
    local interface rx tx now rest elapsed down=0 up=0
    interface=$(network_interface)
    if [[ -z $interface ]] ||
       ! read -r rx 2>/dev/null < "$sys_root/class/net/$interface/statistics/rx_bytes" ||
       ! read -r tx 2>/dev/null < "$sys_root/class/net/$interface/statistics/tx_bytes" ||
       [[ ! $rx =~ ^[0-9]+$ || ! $tx =~ ^[0-9]+$ ]]; then
        network_previous_interface=
        network_text='↓ -- ↑ --'
        return
    fi
    read -r now rest < "$proc_root/uptime"
    if [[ $network_previous_interface == "$interface" ]]; then
        elapsed=$(LC_ALL=C awk -v now="$now" -v previous="$network_previous_time" 'BEGIN {
            elapsed = now - previous; printf "%.6f", (elapsed > 0.001 ? elapsed : 0.001)
        }')
        down=$((rx - network_previous_rx))
        up=$((tx - network_previous_tx))
        ((down >= 0)) || down=0
        ((up >= 0)) || up=0
    else
        elapsed=1
    fi
    network_text=$(LC_ALL=C awk -v down="$down" -v up="$up" -v elapsed="$elapsed" '
        function rate(value) {
            if (value >= 1048576) return sprintf("%.1fM/s", value / 1048576)
            if (value >= 1024) return sprintf("%.0fK/s", value / 1024)
            return sprintf("%.0fB/s", value)
        }
        BEGIN { printf "↓ %s ↑ %s", rate(down / elapsed), rate(up / elapsed) }
    ')
    network_previous_interface=$interface
    network_previous_rx=$rx
    network_previous_tx=$tx
    network_previous_time=$now
}

# Bash printf/awk use ties-to-even rounding, like the original Python output.
weather_parse() {
    local fields code temp day icon
    fields=$(timeout 2 jq -er '.current | select(
        (.weather_code | type) == "number" and
        (.temperature_2m | type) == "number" and
        (.is_day | type) == "number"
    ) | [.weather_code, .temperature_2m, .is_day] | @tsv' "$1" 2>/dev/null) || return 1
    IFS=$'\t' read -r code temp day <<< "$fields"
    case $code in
        0) if ((day)); then icon=$'\uf185'; else icon=$'\uf186'; fi ;;
        1|2|3) icon=$'\uf0c2' ;;
        45|48) icon=$'\uf0c2' ;;
        71|73|75|77|85|86) icon=$'\uf2dc' ;;
        *) if ((code >= 95)); then icon=$'\uf0e7'; else icon=$'\uef1c'; fi ;;
    esac
    LC_ALL=C awk -v icon="$icon" -v temp="$temp" 'BEGIN { printf "%s %.0f°C", icon, temp }'
}

weather_worker() {
    local child_pid= delay label now rest
    trap 'exit 0' TERM INT HUP
    trap 'if [[ -n $child_pid ]]; then kill "$child_pid" 2>/dev/null; wait "$child_pid" 2>/dev/null; fi' EXIT
    while :; do
        delay=900
        curl --fail --silent --show-error --max-time 8 "$weather_url" > "$weather_dir/request.json" &
        child_pid=$!
        if wait "$child_pid" && label=$(weather_parse "$weather_dir/request.json"); then
            read -r now rest < "$proc_root/uptime"
            printf '%s\t%s\n' "$now" "$label" > "$weather_dir/current.tmp"
            mv -- "$weather_dir/current.tmp" "$weather_dir/current"
        else
            printf 'Dhaka weather refresh failed\n' >&2
            delay=300
        fi
        child_pid=
        sleep "$delay" &
        child_pid=$!
        wait "$child_pid"
        child_pid=
    done
}

weather_text() {
    local updated label now rest
    if [[ -n $weather_dir && -r $weather_dir/current ]]; then
        IFS=$'\t' read -r updated label < "$weather_dir/current"
        read -r now rest < "$proc_root/uptime"
        if LC_ALL=C awk -v now="$now" -v updated="$updated" 'BEGIN { exit !(now - updated < 3600) }'; then
            printf '%s' "$label"
            return
        fi
    fi
    printf '\uf0c2 --°C'
}

status() {
    local total idle usage part text= separator=
    local -a parts
    total=$((cpu_total - previous_cpu_total))
    idle=$((cpu_idle - previous_cpu_idle))
    usage=$(LC_ALL=C awk -v total="$total" -v idle="$idle" 'BEGIN {
        printf "%.0f", (total > 0 ? 100 * (total - idle) / total : 0)
    }')
    parts=(
        # "$(recording)"
		"Mehedi"
		"$(gpu_usage)"
        "$cpu_icon $(temperature)  $memory_icon $(memory)"
        "$usage_icon $usage%"
        "$network_text"
        "$(battery)"
        "$(volume)"
        "$(weather_text)"
        "$(LC_TIME=C date '+%A, %b %-d  %-I:%M%P')"
    )
    for part in "${parts[@]}"; do
        [[ -n $part ]] || continue
        text+="$separator$part"
        separator=' | '
    done
    printf '  %s  ' "$text"
}

cleanup() {
    if [[ -n $weather_pid ]]; then
        kill "$weather_pid" 2>/dev/null
        wait "$weather_pid" 2>/dev/null
    fi
    [[ -z $weather_dir ]] || rm -rf -- "$weather_dir"
}

main() {
    local once=0 arg text
    for arg in "$@"; do [[ $arg != --once ]] || once=1; done
    weather_dir=$(mktemp -d "${TMPDIR:-/tmp}/dwm-status.XXXXXXXX") || return 1
    trap cleanup EXIT
    trap 'exit 0' HUP INT TERM
    weather_worker &
    weather_pid=$!
    network_sample
    cpu_sample
    previous_cpu_total=$cpu_total
    previous_cpu_idle=$cpu_idle
    if ((once)); then sleep 0.2; else sleep 1; fi
    while :; do
        cpu_sample
        network_sample
        text=$(status)
        previous_cpu_total=$cpu_total
        previous_cpu_idle=$cpu_idle
        if ((once)); then
            printf '%s\n' "$text"
            return
        fi
        xsetroot -name "$text" >/dev/null 2>&1 || return 0
        sleep 3 &
        wait "$!"
    done
}

if [[ ${BASH_SOURCE[0]} == "$0" ]]; then
    main "$@"
fi
