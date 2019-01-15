#!/bin/zsh

gnuplot <<EOF
set term "svg"
set output "hoge.svg"
set key top left

set xlabel 'Words'
set ylabel 'Time (s)'

plot "rf.time" u 2:3 w lp pt 7 title 'Remove First', "bf.time" u 2:3 w lp pt 9 title 'Best First', "rd.time" u 2:3 w lp pt 5 title 'Random'
EOF
