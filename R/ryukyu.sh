#!/bin/bash

# 引数：出力ディレクトリ名

dir_name=$1
input_file="../data/${dir_name}/input.csv"
output_dir="../data/${dir_name}"

cd r

# PSA
echo "PSA LV"
Rscript execution/execution_psa.R "ld" "$input_file" "$output_dir" "T" >/dev/null
echo

echo "PSA PMI"
Rscript execution/execution_psa.R "pmi" "$input_file" "$output_dir" "T" >/dev/null
echo

echo "PSA PF-PMI"
Rscript execution/execution_psa.R "pf-pmi" "$input_file" "$output_dir" "T" >/dev/null
echo


# MSA
echo "MSA LV"
Rscript execution/execution_msa.R "ld" "$input_file" "$output_dir" "T" >/dev/null
echo

echo "MSA PMI"
Rscript execution/execution_msa.R "pmi" "$input_file" "$output_dir" "T" >/dev/null
echo

echo "MSA PF-PMI"
Rscript execution/execution_msa.R "pf-pmi" "$input_file" "$output_dir" "T" >/dev/null
