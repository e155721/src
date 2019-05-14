#!/bin/zsh

# This script converts the word files name in some files from org to gpu.

org_name=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/org_name))
gpu_name=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/gpu_name))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

for f in *"$ext"
do
    i=1
    for org in $org_name
    do
        sed -i.tmp "s/$org.$ext/$gpu_name[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp