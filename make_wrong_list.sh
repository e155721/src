#!/bin/zsh

# This script is executed for all of files in the directory
# and this is receive only output filename

file=$1
touch $file

for f in *
do org=($(head -n1 $f))
   first=($(<$f | head -n2 | tail -n1))
   org_len=${#org[*]}
   first_len=${#first[*]}
   [ "$org_len" -ne "$first_len" ] && echo $f >>$file
done

file_list=($(<$file))
for f in $file_list
do
    org=($(head -n1 $f))
    offset=${#org[*]}
    offset=$((offset+1))

    miss=$(cut -f"$offset"- -d" " $f | sed 's/\"-1\"//g' | grep \" | tr '\n' ' ' | sed -e 's/[ ]*//g')
    [ -n "$miss" ] && echo $f
done
