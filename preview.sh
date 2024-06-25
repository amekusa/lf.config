#!/usr/bin/env bash

case "$1" in
	*.tar.*) tar tf "$1" ;;
	*) case "${1##*.}" in
		zip) unzip -l "$1" ;;
		rar) unrar l "$1" ;;
		7z) 7z l "$1" ;;
		# pdf) pdftotext "$1" - ;;
		png|PNG|jpg|JPG|jpeg|JPEG|gif)
			opts="--polite=on"
			[ -n "$TMUX" ] && opts="$opts --passthrough=tmux"
			[ "$#" -gt 4 ] && opts="$opts --size=${2}x${3}"
			chafa $opts "$1"
		;;
		*) cat "$1" ;;
	esac ;;
esac

