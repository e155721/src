#!/bin/zsh

input_file=$1
out_file=$2

#<"$input_file" | sed -e 's/-1/_/g' | sed -e 's/-9/NA/g' | sed -e 's/\./NA/g' | cut -f1- -d" " | sed -n 3,100p >"$out_file".check
#<"$input_file" | sed -e 's/-1/_/g' | sed -e 's/-9/NA/g' | sed -e 's/\./NA/g' | cut -f1- -d" " >"$out_file".check
<"$input_file" | sed -e 's/-1/\-/g' | cut -f1- -d" " >"$out_file:r".correct
