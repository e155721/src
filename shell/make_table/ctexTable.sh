#!/bin/zsh

dir="table"

for f in *.tex
do

    platex "$f"
    dvipdfmx "$f:r.dvi"

    platex "$f"
    dvipdfmx "$f:r.dvi"

done

mkdir "$dir"
mv *.pdf "$dir"

rtex
