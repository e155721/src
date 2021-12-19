#!/bin/bash

# 引数：出力ディレクトリ名

base="/var/www/html"

dir_name=$1
input_file="${base}/data/${dir_name}/input.csv"
output_dir="${base}/data/${dir_name}"

cd ${base}/r

function error_check () {
    if [ $? -ne 0 ]; then
        exit
    fi
}

# MSA
echo "MSA PMI"
Rscript execution/execution_msa.R "pmi" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "pmi" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "pmi" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_pmi"
echo
