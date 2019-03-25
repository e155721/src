#!/bin/zsh

ALN_TYP=$1
if [ "$ALN_TYP" = 1 ]; then
    ALN_TYP="Pairwise Alignment"
elif [ "$ALN_TYP" = 2 ]; then
    ALN_TYP="Multiple Alignment"
else
    echo "ERROR!!"
    exit
fi

files=(*.tex)

for f in $files
do
    sed -i.tmp 's/^.*¥ &//' "$f"

    # remove table
    sed -i.tmp 's/\\begin{table}\[ht\]//' "$f"
    sed -i.tmp 's/\\end{table}//' "$f"

    # change tabular to longtable
    sed -i.tmp 's/tabular/longtable/' "$f"

    align="$(echo $f:r | cut -f2 -d"-")"
    aln="$(echo $f:r | cut -f3 -d"-")"
    lg="$(echo $f:r | cut -f4 -d"-")"

    out="$(echo $f | sed 's/-.*-.'//)"

    line=$(<"$f" grep -n "longtable" | head -n1 | cut -f1 -d":")
    line=$((line+3))
    cat <<EOF | sed -i.tmp "${line}r /dev/stdin" "$f"
     \multicolumn{$align}{c}{$out} \\\\
     \hline
     & \multicolumn{1}{c}{Region Name}
     & \multicolumn{$aln}{c|}{$ALN_TYP}
     & \multicolumn{$lg}{c}{Linguists} \\\\
     \hline
EOF

    sed -i.tmp 's/\-/$\-$/g' "$f"
    mv "$f" "$out"
done

rm *.tmp

/Users/e155721/OkazakiLab/Experiment/src/shell/gpu2orgInFile.sh tex
/Users/e155721/OkazakiLab/Experiment/src/shell/regSym2regNam.sh tex
