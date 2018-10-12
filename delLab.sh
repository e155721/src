#!/bin/zsh

inFile=$1
outFile=$1.tmp

line=($(wc -l $inFile))
tail -n $((line[1]-2)) $inFile >$outFile
mv $outFile $inFile
