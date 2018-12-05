#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/org_name))

# echo $gpu_name
# echo $org_name

for f in *
do
    i=1
    for gn in $gpu_name
    do
        sed -i.back "s/${gn}.dat/$org_name[$i]/" "$f"
        i=$((i+1))
    done
    rm *.back
done
