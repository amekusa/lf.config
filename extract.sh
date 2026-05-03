#!/usr/bin/env bash

_cmd() {
	local cmd="$1"; shift
	if command -v "$cmd" &> /dev/null; then
		"$cmd" "$@"
	else
		echo "Command not found: '$cmd'"
		return 1
	fi
}

_extract() {
	if [ $# = 0 ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
		cat <<- EOF
		Extracts a various types of archive.
		- Usage:
		  ${0} <archive>
		EOF
		return 1
	fi
	local src="$1"
	if [[ "$src" =~ ^(.+)\.(zip|7z|rar|tar|tar\.t?(gz|xz|bz2?))$ ]]; then
		local dst="${BASH_REMATCH[1]}"
		local ext="${BASH_REMATCH[2]}"
		echo "Extracting: '$src' ..."
		echo "> dst: '$dst'"
		if [ -d "$dst" ]; then
			echo "[WARN] Directory already exists."
			local answer
			while true; do
				read -n 1 -p "Delete and recreate '$dst'? (Y/N) " answer; echo
				case "$answer" in
				[Yy])
					rm -r -- "$dst" || return 1
					echo "Deleted: '$dst'."
					break
					;;
				[Nn])
					echo "Canceled."; return 1
					;;
				*)
					echo "Type Y or N."
				esac
			done
		elif [ -e "$dst" ]; then
			echo "[ERROR] Destination already exists."
			return 1
		fi
		mkdir -p "$dst" || return 1
		echo "Created: '$dst'."
		case "$ext" in
		tar.bz|tar.bz2|tar.tbz|tar.tbz2) _cmd tar xjvf "$src" -C "$dst" ;;
		tar.gz|tar.tgz) _cmd tar xzvf "$src" -C "$dst" ;;
		tar.xz|tar.txz) _cmd tar xJvf "$src" -C "$dst" ;;
		zip) _cmd unzip "$src" -d "$dst" ;;
		rar) _cmd unrar x "$src" "$dst" ;;
		7z)  _cmd 7z x "$src" -o"$dst" ;;
		esac
	else
		echo "[ERROR] Invalid file: '$src'."
		return 1
	fi
}

_extract "$@"

