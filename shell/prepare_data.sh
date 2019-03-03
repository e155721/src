#!/bin/zsh

# Descripttion: This script does preprocess org_data.
# Arguments: This script do not have any arguments.

# remove files that there have the word of original form

for f in *.org
do
    l=($(grep -v "\-9" $f | wc -l))
    [ $l[1] -le 2 ] && rm $f
done

for f in *.org
do
    <"$f" | sed -e 's/"-"/NA/g' | sed -e 's/"-9"/NA/g' >"$f:r".input
    <"$f" | sed -e 's/"-9"/NA/g' >"$f:r".correct
done
