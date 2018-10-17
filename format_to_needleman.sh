#!/bin/zsh

# Description: This script formats a file type .org to .input.
# Arguments: This script received only two arguments that one is input filename and other one is output filename.

input_file=$1
out_file=$2

#<"$input_file" | sed -e 's/"-1"/NA/g' | sed -e 's/"-9"/NA/g' | sed -e 's/"\."/NA/g' | cut -f1- -d" " | sed -n 3,100p >"$out_file"
#<"$input_file" | sed -e 's/"-1"/NA/g' | sed -e 's/"-9"/NA/g' | sed -e 's/"\."/NA/g' | cut -f1- -d" " >"$out_file"
<"$input_file" | sed -e 's/"-1"/NA/g' | cut -f1- -d" " >"$out_file:r".dat
