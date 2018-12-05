#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/org_name))

i=1; for f in $gpu_name; do mv $f.org $org_name[$i].org; i=$((i+1)); done
i=1; for f in $gpu_name; do mv $f.dat $org_name[$i].dat; i=$((i+1)); done
i=1; for f in $gpu_name; do mv $f.correct $org_name[$i].correct; i=$((i+1)); done
