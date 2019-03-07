#!/bin/zsh

org_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/org_name))
gpu_name=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/gpu_name))

for f in *
do
    i=1
    for org in $org_name
    do
        sed -i.tmp "s/$org$/$gpu_name[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
