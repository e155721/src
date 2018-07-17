#!/bin/zsh

inFile=$1
outFile=$2

<"$inFile" | sed -e 's/"//g' | sed -e 's/-9//g' | sed -e 's/-1//g' | tr '.' ' ' | cut -f2- -d" " | sed -n 3,100p >"$outFile"
