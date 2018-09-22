#!/bin/zsh

inFile=$1
outFile=$2
for f (*) cat $f | sed -e 's/NA//g' | sed -e 's/^ /#/' | grep -v \^\# >$f
