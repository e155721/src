#!/bin/zsh

files=(*.tex)

for f in $files
do
    sed -i.tmp 's/^.*¥ &//' "$f"

    # remove table
    sed -i.tmp 's/\\begin{table}\[ht\]//' "$f"
    sed -i.tmp 's/\\end{table}//' "$f"

    # change tabular to longtable
    sed -i.tmp 's/tabular/longtable/' "$f"

    line=$(<"$f" grep -n "longtable" | head -n1 | cut -f1 -d":")
    line=$((line+3))
    cat <<EOF | sed -i.tmp "${line}r /dev/stdin" "$f"
    % \multicolumn{1}{c}{"$f"} \\\\
    % \hline
    % & \multicolumn{1}{c}{Region Name}
    % & \multicolumn{1}{c|}{Pairwise Alignment}
    % & \multicolumn{1}{c}{Linguists}\\\\
    % \hline
EOF

    sed -i.tmp 's/\-/$\-$/g' "$f"
done

rm *.tmp

/Users/e155721/OkazakiLab/Experiment/src/shell/gpu2orgInFile.sh tex
/Users/e155721/OkazakiLab/Experiment/src/shell/regSym2regNam.sh tex
