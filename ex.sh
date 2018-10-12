#!/bin/zsh

inFile=$1
outFile=$1.tmp

head=($(head -n1 "$inFile"))
len=${#head[*]}
i=1
while [ $i -le $len ]
do
    if [ "$head[$i]" = "\".\"" ]; then
        i=$((i-1))
        cut -f2-$i -d" " "$inFile" >"$outFile"
        mv "$outFile" "$inFile"
        exit
    fi
    i=$((i+1))
done
