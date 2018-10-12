#!/bin/zsh

inFile=$1
outFile=$2

#<"$inFile" | sed -e 's/"-1"/NA/g' | sed -e 's/"-9"/NA/g' | sed -e 's/"\."/NA/g' | cut -f1- -d" " | sed -n 3,100p >"$outFile"
<"$inFile" | sed -e 's/"-1"/NA/g' | sed -e 's/"-9"/NA/g' | sed -e 's/"\."/NA/g' | cut -f1- -d" " >"$outFile"
