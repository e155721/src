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
echo "MSA LD"
Rscript execution/execution_msa.R "ld" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "ld" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "ld" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_ld"
error_check
echo

echo "MSA LD2"
Rscript execution/execution_msa.R "ld2" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "ld2" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "ld2" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_ld2"
error_check
echo

echo "MSA PMI"
Rscript execution/execution_msa.R "pmi" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "pmi" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "pmi" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_pmi"
error_check
echo

echo "MSA PF-PMI1"
Rscript execution/execution_msa.R "pf-pmi1" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "pf-pmi1" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "pf-pmi1" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_pf-pmi1"
error_check
echo

echo "MSA PF-PMI2"
Rscript execution/execution_msa.R "pf-pmi2" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "pf-pmi2" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "pf-pmi2" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_pf-pmi2"
error_check
echo

echo "MSA PF-PMI3"
Rscript execution/execution_msa.R "pf-pmi3" "$input_file" "$output_dir" "T" >/dev/null
error_check

Rscript execution/execution_phylo_each_word.R "pf-pmi3" "$output_dir"
error_check

Rscript execution/execution_phylo_all_word.R "pf-pmi3" "$output_dir"
error_check

./admixture.sh "${output_dir}/msa_pf-pmi3"
error_check
echo
