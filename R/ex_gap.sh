#!/bin/zsh

OUT="/dev/zero"

input_dir="../../Alignment/ryukyuan/"
output_dir=$(Rscript scripts/make_output_dir.R | tail -n1 | cut -f2 -d" ")
echo $output_dir

# PSA
echo "PSA: LD"
start_time=$(date +%s)
Rscript ex_gap/psa_ld.R ld $input_dir $output_dir 5
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: LD2"
start_time=$(date +%s)
Rscript ex_gap/psa_ld.R ld2 $input_dir $output_dir 5
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

# MSA
echo "MSA: LD"
start_time=$(date +%s)
Rscript ex_gap/msa_ld.R ld $input_dir $output_dir 5
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "MSA: LD2"
start_time=$(date +%s)
Rscript ex_gap/msa_ld.R ld2 $input_dir $output_dir 5
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
