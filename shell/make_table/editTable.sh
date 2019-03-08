#!/bin/zsh

dir="edit_table"
mkdir "$dir"
cp *.tex "$dir"
cd "$dir"

files=(*.tex)
list="list"
for f in $files
do
    echo \\input{"$f"} >>"$list"
done

out="edit_table.tex"
cat >"$out" <<EOF
\documentclass[a4j]{jarticle}
\usepackage{longtable}

\author{}
\date{}
\title{}

% "$f:r"
\begin{document}
\pagestyle{empty}

$(<list)

\end{document}
EOF
rm "$list"
