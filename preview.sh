#!/usr/bin/env bash

columned=false; [ $# -gt 4 ] && columned=true

_cmd() {
	local cmd="$1"; shift
	if command -v "$cmd" &> /dev/null; then
		"$cmd" "$@"
	else
		echo "command not found: '$cmd'"
		return 1
	fi
}

case "$1" in
	*.tar.*) tar tf "$1" ;;
	*) case "${1##*.}" in
		zip) _cmd unzip -l "$1" ;;
		rar) _cmd unrar l "$1" ;;
		7z)  _cmd 7z l "$1" ;;
		pdf) _cmd pdftotext "$1" - ;;
		png|PNG|jpg|JPG|jpeg|JPEG|gif)
			opts="--polite on --color-space din99d --animate off"
			opts="$opts --symbols sextant"
			opts="$opts+quad+half+solid"
			opts="$opts+u2582..u2586"
			opts="$opts+u258b..u258d"
			opts="$opts+u25cf" # ●
			opts="$opts+u25a0" # ■
			# opts="$opts+u25c6" # ◆ (doesn't work)
			[ -n "$TMUX" ] && opts="$opts --passthrough tmux"
			if $columned
				then opts="$opts -w 5 --size $(( $2 > 100 ? 100 : $2 ))x${3}" # cap width to 100
				else opts="$opts -w 9 --scale max --align center"
			fi
			_cmd chafa $opts "$1"
		;;
		*) cat "$1" ;;
	esac ;;
esac

