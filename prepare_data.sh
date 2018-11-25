#!/bin/zsh

# Descripttion: This script does preprocess org_data.
# Arguments: This script do not have any arguments.

# remove files that there have the word of original form

pwd
for f in *.org
do
    l=($(grep -v "\-9" $f | wc -l))
    [ $l[1] -le 2 ] && rm $f
done
