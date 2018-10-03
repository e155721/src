#!/bin/zsh

BASE=data-2
check=($(<$1))

for f in $check
do
  c="$(grep "$f" "$BASE")"
  [ -z "$c" ] && echo "$f"
done
