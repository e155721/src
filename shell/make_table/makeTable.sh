#!/bin/zsh

DIR="$(pwd)"
SRC="$HOME/OkazakiLab/Experiment/src/R/"
RSCRIPT="data_processing/MakeTable.R"

cd "$SRC"
Rscript "$RSCRIPT" "$DIR"
