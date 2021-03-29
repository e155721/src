#!/bin/bash

# 引数：出力ディレクトリ名

base="/var/www/html"

dir_name=$1
input_file="${base}/data/${dir_name}/input.csv"
output_dir="${base}/data/${dir_name}"

cd ${base}/r

# MSA
echo "MSA LD"
Rscript execution/execution_msa.R "ld" "$input_file" "$output_dir" "T" >/dev/null
echo
./admixture.sh "${output_dir}/msa_ld"
