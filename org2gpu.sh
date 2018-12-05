#!/bin/zsh

gpu_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/gpu_name))
org_name=($(</Users/e155721/OkazakiLab/Experiment/Alignment/org_name))

i=1; for f in $org_name; do mv $f.org $gpu_name[$i].org; i=$((i+1)); done
i=1; for f in $org_name; do mv $f.dat $gpu_name[$i].dat; i=$((i+1)); done
i=1; for f in $org_name; do mv $f.correct $gpu_name[$i].correct; i=$((i+1)); done
