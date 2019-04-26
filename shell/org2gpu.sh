#!/bin/zsh

# This script converts the word files name from org to gpu.

gpu_name=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/gpu_name))
org_name=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/org_name))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

i=1
for f in $org_name
do
    mv "$f"."$ext" "$gpu_name[$i]"."$ext"
    i="$((i+1))"
done
