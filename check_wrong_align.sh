#!/bin/zsh

file=$1
out=$2

<"$file" | grep -v " 100" | grep dat | cut -f2- -d" " >data-${out}.txt
