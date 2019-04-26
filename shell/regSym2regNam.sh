#!/bin/zsh

# This script convers the regions symbol in specified files to regions name.

regions=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/regions_sym))
regionsName=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/regions_name))

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
