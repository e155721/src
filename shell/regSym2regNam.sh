#!/bin/zsh

regions=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/regions_sym))
regionsName=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/regions_name))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

for f in *."$ext"
do
    i=1
    for r in $regions
    do
        sed -i.tmp "s/$r/$regionsName[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
