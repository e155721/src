#!/bin/bash

# 実行方法：Rscript "Rスクリプト名" "入力ファイル" "出力ディレクトリ"

# PSA
echo "PSA LV"
Rscript execution_psa/execution_lv.R "input.csv" "psa_lv/" >/dev/null
echo

echo "PSA PMI"
Rscript execution_psa/execution_pmi.R "input.csv" "psa_pmi/" >/dev/null
echo

echo "PSA PF-PMI"
Rscript execution_psa/execution_pf-pmi.R "input.csv" "psa_pf-pmi/" >/dev/null
echo


# MSA
echo "MSA LV"
Rscript execution_msa/execution_msa_lv.R "input.csv" "msa_lv/" >/dev/null
echo

echo "MSA PMI"
Rscript execution_msa/execution_msa_pmi.R "input.csv" "msa_pmi/" >/dev/null
echo

echo "MSA PF-PMI"
Rscript execution_msa/execution_msa_pf-pmi.R "input.csv" "msa_pf-pmi/" >/dev/null
