#!/bin/zsh

input_file=$1
output_file=$2

<"$input_file" | grep -v V1 >"$output_file"
