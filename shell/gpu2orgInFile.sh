#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/org_name))

for f in *
do
    i=1
    for gpu in $gpu_name
    do
        sed -i.tmp "s/$gpu$/$org_name[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
