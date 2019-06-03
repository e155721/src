#!/bin/zsh

aln=(*.aln)
lg=(*.lg)
files+=($aln)
files+=($lg)

for f in $files
do
    <"$f" cut -f2- -d" " >"$f".tmp
    mv "$f".tmp "$f"
done

for f in $files
do
    sed -i.tmp 's/"//g' "$f"
done

rm *.tmp

# remove the region symbols from .lg files
for f in $lg
do
    <"$f" cut -f2- -d" " >"$f".tmp
    mv "$f".tmp "$f"
done
