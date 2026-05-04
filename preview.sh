#!/usr/bin/env bash

_has() {
	command -v "$1" &> /dev/null
}

_cmd() {
	local cmd="$1"; shift
	if _has "$cmd"; then
		"$cmd" "$@"
	else
		echo "Command not found: '$cmd'"
		return 1
	fi
}

_preview() {
	local columned=false
	local w=100
	local h=100
	if [ $# -gt 4 ]; then
		columned=true
		w=$(( $2 - 0 ))
		h=$(( $3 - 0 ))
	fi

	case "$(echo -- "$1" | tr '[:upper:]' '[:lower:]')" in
	*.tar.*) _cmd tar tf "$1" ;;
	*)
		case "${1##*.}" in
		zip) _cmd unzip -l "$1" ;;
		rar) _cmd unrar l "$1" ;;
		7z)  _cmd 7z l "$1" ;;
		pdf) _cmd pdftotext "$1" - ;;

		png|jpg|jpeg|gif)
			# chafa options
			local opts
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
				then opts="$opts -w 5 --size $(( $w > 100 ? 100 : $w ))x${h}" # cap width to 100
				else opts="$opts -w 9 --scale max --align center"
			fi
			_cmd chafa $opts "$1"
			;;
		md)
			if _has mcat; then
				mcat -Pc --ascii --sc ${w}x${h} --theme kanagawa "$1"
			else
				cat "$1"
			fi
			;;
		*)
			cat "$1"
		esac
		;;
	esac
}

_preview "$@"

