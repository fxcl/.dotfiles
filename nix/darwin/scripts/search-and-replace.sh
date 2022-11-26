#!/usr/bin/env bash
set -e

[ "$1" = "-h" ] && exec sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' < "$0"

word=""
if [ "$1" == "-w" ]; then
	word="$1"
	shift 1
fi

num_files=0
has_error=0

pt -l $word "$1" | while read file; do
	sed -i.bak "s|${word:+[[:<:]]}${1}${word:+[[:>:]]}|${2}|g" "$file"

	if diff -q "$file" "${file}.bak" >/dev/null; then
		echo "Warning: ${file}: pattern found, but no substitutions made" >&2
		: $((has_error++))
	else
		echo "$file"
	fi

	rm "${file}.bak"
	: $((num_files++))
done

if [ $num_files -eq 0 ] || [ $has_error -gt 0 ]
then
	exit 1
fi
