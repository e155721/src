#!/bin/zsh

ext1=$1
ext2=$2

DIR="$(pwd)"
SRC="$HOME/OkazakiLab/Experiment/src/R/"
RSCRIPT="data_processing/MakeTable.R"

cd "$SRC"
Rscript "$RSCRIPT" "$DIR" "$ext1" "$ext2"
