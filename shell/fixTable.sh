#!/bin/zsh

for f (*.tex)
do
    sed -i.tmp 's/^.*¥ &//' "$f"
done

rm *.tmp
