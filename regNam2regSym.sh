#!/bin/zsh

regions=($(</Users/e155721/OkazakiLab/Experiment/Alignment/regions))
regionsName=($(</Users/e155721/OkazakiLab/Experiment/Alignment/regionsName))

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
