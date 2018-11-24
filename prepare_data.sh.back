#!/bin/zsh

# Descripttion: This script does preprocess org_data.
# Arguments: This script do not have any arguments.

# remove blanks of filename
for f in *
do
    mv $f $(echo $f | sed 's/*[ ]*//g')
done

# labels delete
for f in *.org
do
    outFile=$f.tmp

    line=($(wc -l $f))
    tail -n $((line[1]-2)) $f >$outFile
    mv $outFile $f
done

# cut by a max length word from data file
for f in *.org
do
    outFile=$f.tmp

    head=($(head -n1 "$f"))
    len=${#head[*]}
    i=1
    while [ $i -le $len ]
    do
        if [ "$head[$i]" = "\".\"" ]; then
            i=$((i-1))
            cut -f2-$i -d" " "$f" >"$outFile"
            mv "$outFile" "$f"
            break
        fi
        i=$((i+1))
    done
done

# remove lines that there have only "-9"
for f in *.org
do
    outFile=$f.tmp
    <$f | grep -v "\-9" >$outFile
    mv $outFile $f
done

# remove files that there have the word of original form
for f in *.org
do
    l=($(wc -l $f))
    [ $l[1] -eq 1 ] && rm $f
done
