#!/bin/zsh

regions=($(</Users/e155721/OkazakiLab/Experiment/src/shell/name_table/regions_sym))
regionsName=($(</Users/e155721/OkazakiLab/Experiment/src/shell/name_table/regions_name))

for f in *
do
    i=1
    for r in $regionsName
    do
        sed -i.tmp "s/$r/$regions[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
