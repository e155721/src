#!/bin/bash

# 実行方法：Rscript "Rスクリプト名" "入力ディレクトリ" "出力ディレクトリ"

# PSA
echo "PSA LV"
Rscript execution_psa/execution_lv.R "data/" "psa_lv/" >/dev/null
echo

echo "PSA PMI"
Rscript execution_psa/execution_pmi.R "data/" "psa_pmi/" >/dev/null
echo

echo "PSA PF-PMI"
Rscript execution_psa/execution_pf-pmi.R "data/" "psa_pf-pmi/" >/dev/null
echo


# MSA
echo "MSA LV"
Rscript execution_msa/execution_msa_lv.R "data/" "msa_lv/" >/dev/null
echo

echo "MSA PMI"
Rscript execution_msa/execution_msa_pmi.R "data/" "msa_pmi/" >/dev/null
echo

echo "MSA PF-PMI"
Rscript execution_msa/execution_msa_pf-pmi.R "data/" "msa_pf-pmi/" >/dev/null
