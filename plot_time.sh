#!/bin/zsh

gnuplot <<EOF
set term "svg"
set output "hoge.svg"
set key top left
set xrange [10:110]

set xlabel 'Words'
set ylabel 'Time (s)'

plot "rf.time" u 2:3 w lp pt 5 title 'Remove First',\
 "bf.time" u 2:3 w lp pt 7 title 'Best First',\
 "bf.time-par" u 2:3 w lp pt 9 title 'Best First (Parallelize)',\
 "rd.time" u 2:3 w lp pt 13 title 'Random'
EOF
