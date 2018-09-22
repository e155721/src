#!/bin/zsh

for f in *; do l=($(wc -l $f)); [ $l[1] -eq 1 ] && echo $f; done
