#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/src/name_table/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/src/name_table/org_name))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

i=1
for f in $gpu_name
do
    mv "$f"."$ext" "$org_name[$i]"."$ext"
    i="$((i+1))"
done
