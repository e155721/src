#!/bin/zsh

# make origin data

inFile=$1
outFile=$2

<"$inFile" | sed -e 's/"-9"/NA/g' | sed -e 's/"\."/NA/g' |cut -f2- -d" " | sed -n 3,100p | grep -v '^NA' | grep -v '^\s' >"$outFile"
