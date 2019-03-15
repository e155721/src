#!/bin/zsh

DIR="$(pwd)"
SRC="/Users/e155721/OkazakiLab/Experiment/src/R/"
RSCRIPT="data_processing/MakeTable.R"

cd "$SRC"
Rscript "$RSCRIPT" "$DIR"
