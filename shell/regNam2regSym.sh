#!/bin/zsh

regionsName=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/regions_name))
regions=($(</Users/e155721/OkazakiLab/Experiment/src/data/name_table/regions_sym))

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
        sed -i.tmp "s/$r/$regions[$i]/" "$f"
        i=$((i+1))
    done
done

rm *.tmp
