#!/bin/zsh

outFile=$1
for f (*) cat $f | sed -e 's/NA//g' | sed -e 's/^ /#/' | grep -v \^\# >$outFile/$f
