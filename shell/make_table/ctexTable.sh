#!/bin/zsh


files=(*.tex)

dir="table"
mkdir "$dir"
cd "$dir"

for f in $files
do
    mv ../"$f" .

    platex "$f"
    dvipdfmx "$f:r.dvi"

    platex "$f"
    dvipdfmx "$f:r.dvi"

    rm "$f"

done

rtex
