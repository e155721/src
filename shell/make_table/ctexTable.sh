#!/bin/zsh


files=(*.tex)

dir="table"
mkdir "$dir"
cd "$dir"

for f in $files
do

    cat >"$f" <<EOF
\documentclass[a4j]{jarticle}
\usepackage{longtable}

\author{}
\date{}
\title{}

% "$f:r"
\begin{document}
\pagestyle{empty}

\input{../"$f"}

\end{document}
EOF

    ctex
    ctex
    rm "$f"

done

rtex

# /Users/e155721/OkazakiLab/Experiment/src/shell/gpu2org.sh pdf
