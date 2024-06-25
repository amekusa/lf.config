#!/usr/bin/env bash

_columned=false; [ $# -gt 4 ] && _columned=true

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
			opts="--polite on -f symbols --margin-right 1"
			[ -n "$TMUX" ] && opts="$opts --passthrough tmux"
			if $_columned
				then opts="$opts --size ${2}x${3}"
				else opts="$opts --scale max --align center"
			fi
			chafa $opts "$1"
		;;
		*) cat "$1" ;;
	esac ;;
esac

