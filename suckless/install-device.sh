#!/bin/sh
# Install the binaries already built in .local on this machine.
set -eu

if [ "$(id -u)" -ne 0 ]; then
    printf '%s\n' 'Run this installer with sudo.' >&2
    exit 1
fi

source_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
stage="$source_dir/.local"

for file in \
    bin/dwm bin/dmenu bin/dmenu_path bin/dmenu_run bin/stest bin/st \
    share/man/man1/dwm.1 share/man/man1/dmenu.1 share/man/man1/st.1; do
    if [ ! -f "$stage/$file" ]; then
        printf 'Missing staged file: %s\n' "$stage/$file" >&2
        exit 1
    fi
done

mkdir -p /usr/local/share/suckless-backups
backup_dir=$(mktemp -d /usr/local/share/suckless-backups/install-XXXXXXXX)
for target in \
    /usr/local/bin/dwm /usr/local/bin/dmenu /usr/local/bin/dmenu_path \
    /usr/local/bin/dmenu_run /usr/local/bin/stest /usr/local/bin/st; do
    if [ -e "$target" ]; then
        mkdir -p "$backup_dir$(dirname -- "$target")"
        cp -a -- "$target" "$backup_dir$target"
    fi
done

for name in dwm dmenu dmenu_path dmenu_run stest st; do
    install -Dm755 "$stage/bin/$name" "/usr/local/bin/$name"
done
for name in dwm dmenu stest st; do
    install -Dm644 "$stage/share/man/man1/$name.1" "/usr/local/share/man/man1/$name.1"
done
tic -x -o /usr/share/terminfo "$source_dir/st/st.info"

printf 'Installed dwm, dmenu, and st. Previous launchers are in %s\n' "$backup_dir"
printf '%s\n' 'Your existing ~/.xinitrc already starts dwm-session.'
