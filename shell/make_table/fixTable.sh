#!/bin/zsh

files=(*.tex)

for f in $files
do
    sed -i.tmp 's/^.*¥ &//' "$f"

    sed -i.tmp 's/\\begin{table}\[ht\]/#/' "$f"
    sed -i.tmp "s/#/% $f/" "$f"
    sed -i.tmp 's/\\end{table}//' "$f"

    sed -i.tmp 's/tabular/longtable/' "$f"

    sed -i.tmp 's/\-/$\-$/g' "$f"
done

rm *.tmp

/Users/e155721/OkazakiLab/Experiment/src/shell/gpu2orgInFile.sh tex
/Users/e155721/OkazakiLab/Experiment/src/shell/regSym2regNam.sh tex
