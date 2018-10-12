#!/bin/zsh

file=$1
out=$2

<"$file" | grep " 100" | cut -f2 -d" " >data-${out}.txt
