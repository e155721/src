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

    # extract word and output file name
    word="$(echo $f:r | cut -f1 -d"_")"
    out="$(echo $f | sed 's/_.*-.'//)"

    # extract table information
    tb_info="$(echo $f:r | cut -f2 -d"_")"
    align="$(echo $tb_info:r | cut -f1 -d"-")"
    aln="$(echo $tb_info:r | cut -f2 -d"-")"
    lg="$(echo $tb_info:r | cut -f3 -d"-")"

    line=$(<"$f" grep -n "longtable" | head -n1 | cut -f1 -d":")
    sed -i.tmp "$((line+1)),$((line+3))d" "$f"

    # rewrite to longtable
    cat <<EOF | sed -i.tmp "${line}r /dev/stdin" "$f"
\multicolumn{$align}{c}{$word} \\\\
\hline
& \multicolumn{1}{c}{Region Name}
& \multicolumn{$aln}{c|}{$ALN_TYP}
& \multicolumn{$lg}{c}{Linguists} \\\\
\hline
EOF

    # begin TeX
    cat <<EOF | sed -i.tmp "$3r /dev/stdin" "$f"
\documentclass[a4j]{jarticle}
\usepackage{longtable}
\author{}
\date{}
\title{}
\begin{document}
\pagestyle{empty}

EOF

    # end TeX
    line=($(wc -l $f))
    cat <<EOF | sed -i.tmp "${line[1]}r /dev/stdin" "$f"
\end{document}
EOF

    sed -i.tmp 's/\-/$\-$/g' "$f"
    mv "$f" "$out"
done

rm *.tmp
