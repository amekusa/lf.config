#!/usr/bin/env bash

_cmd() {
	local cmd="$1"; shift
	if command -v "$cmd" &> /dev/null; then
		"$cmd" "$@"
	else
		echo "command not found: '$cmd'"
		return 1
	fi
}

_preview() {
	local columned=false
	[ $# -gt 4 ] && columned=true

	case "$1" in
	*.tar.*) _cmd tar tf "$1" ;;
	*)
		case "${1##*.}" in
		zip) _cmd unzip -l "$1" ;;
		rar) _cmd unrar l "$1" ;;
		7z)  _cmd 7z l "$1" ;;
		pdf) _cmd pdftotext "$1" - ;;

		png|PNG|jpg|JPG|jpeg|JPEG|gif)
			# chafa options
			opts="--polite on --color-space din99d --animate off --dither none"
			opts="$opts --symbols quad+half+solid"
			opts="$opts+sextant"
			opts="$opts+u2581..u2587"
			opts="$opts+u258b..u258d"
			opts="$opts+u2578+u257a+u2501" # ╸ ╺ ━
			opts="$opts+u2579+u257b+u2503" # ╹ ╻ ┃
			opts="$opts+u250f+u2513+u2517+u251b" # ┏ ┓ ┗ ┛
			opts="$opts+u2523+u252b+u2533+u253b+u254b" # ┣ ┫ ┳ ┻ ╋
			opts="$opts+u25a0" # ■
			[ -n "$TMUX" ] && opts="$opts --passthrough tmux"
			if $columned
				then opts="$opts -w 5 --size $(( $2 > 100 ? 100 : $2 ))x${3}" # cap width to 100
				else opts="$opts -w 9 --scale max --align center"
			fi
			_cmd chafa $opts "$1"
			;;

		*) cat "$1" ;;
		esac
		;;
	esac
}

_preview "$@"

