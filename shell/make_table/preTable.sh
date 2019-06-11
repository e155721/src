#!/bin/zsh

aln=(*.aln)
lg=(*.lg)
files+=($aln)
files+=($lg)

for f in $aln
do
    <"$f" sed 's/\[1\]//' >"$f:r.txt"
done

for f in $files
do
    sed -i.tmp 's/^.*\][ ]//' "$f"
done

rm *.tmp

# remove the region symbols from .lg files
for f in $lg
do
    <"$f" cut -f2- -d" " >"$f".tmp
    mv "$f".tmp "$f"
done
