#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/org_name))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

for f in *"$ext"
do
    i=1
    for gpu in $gpu_name
    do
        sed -i.tmp "s/$gpu.$ext/$org_name[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
