#!/bin/zsh

#dir="admixture"
#dir="../../Alignment/202103181617/msa_ld/"
dir=$1

Rscript admixture/admixture.R "$dir"
Rscript admixture/concat.R "${dir}/cons_fas/" "${dir}/cons_fas/cons.fas"
Rscript admixture/concat.R "${dir}/vowe_fas/" "${dir}/vowe_fas/vowe.fas"

mkdir "${dir}/infile_fol"
cp "${dir}/cons_fas/cons.fas" "${dir}/infile_fol"
cp "${dir}/vowe_fas/vowe.fas" "${dir}/infile_fol"
Rscript admixture/concat.R "${dir}" "${dir}/0_all_site_jp.fas"

cd "$dir"
snp-sites -v 0_all_site_jp.fas > 0_all_site_jp.vcf
vcftools --vcf 0_all_site_jp.vcf --plink --out 0_all_site_jp
plink --file 0_all_site_jp --recode12 -out 0_all_site_jp
