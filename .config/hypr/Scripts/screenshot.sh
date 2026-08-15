#!/usr/bin/env bash

set -euo pipefail

screenshot_dir="${XDG_PICTURES_DIR:-${HOME}/Pictures}/Screenshots"
mkdir -p "${screenshot_dir}"

case "${1:-region}" in
	region|window|output)
		hyprshot --freeze --mode "$1" --output-folder "${screenshot_dir}"
		;;
	annotate)
		geometry="$(slurp)" || exit 0
		filename="${screenshot_dir}/Screenshot-$(date '+%Y%m%d-%H%M%S').png"
		grim -g "${geometry}" - | satty \
			--filename - \
			--output-filename "${filename}" \
			--copy-command wl-copy
		;;
	*)
		printf 'Usage: %s {region|window|output|annotate}\n' "$0" >&2
		exit 2
		;;
esac
