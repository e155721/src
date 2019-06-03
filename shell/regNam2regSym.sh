#!/bin/zsh

# This script convers the regions name in specified files to regisons symbol.

regionsName=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/regions_name))
regions=($(<$HOME/OkazakiLab/Experiment/src/data/name_table/regions_sym))

ext=$1

if [ -z "$ext" ]; then
    echo "ERROR!"
    exit
fi

for f in *."$ext"
do
    i=1
    for r in $regionsName
    do
        sed -i.tmp "s/$r/$regions[$i]/g" "$f"
        i=$((i+1))
    done
done

rm *.tmp
