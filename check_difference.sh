#!/bin/zsh

base=$1
check=($(<$2))

for f in $check
do
  c="$(grep "$f" "$base")"
  [ -z "$c" ] && echo "$f"
done
