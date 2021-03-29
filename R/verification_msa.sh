#!/bin/zsh

OUT="/dev/zero"

input_dir="../../Alignment/ryukyuan/"
#input_dir="../../Alignment/bulgarian/"
output_dir=$(Rscript scripts/make_output_dir.R | tail -n1 | cut -f2 -d" ")
echo $output_dir

echo "MSA: LD"
start_time=$(date +%s)
Rscript verification/verification_msa.R ld $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_ld"

echo "MSA: LD2"
start_time=$(date +%s)
Rscript verification/verification_msa.R ld2 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_ld2"

echo "MSA: PF-PMI0"
start_time=$(date +%s)
Rscript verification/verification_msa.R pf-pmi0 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_pf-pmi0"

echo "MSA: PMI"
start_time=$(date +%s)
Rscript verification/verification_msa.R pmi $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_pmi"

echo "MSA: PF-PMI1"
start_time=$(date +%s)
Rscript verification/verification_msa.R pf-pmi1 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_pf-pmi1"

echo "MSA: PF-PMI2"
start_time=$(date +%s)
Rscript verification/verification_msa.R pf-pmi2 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_pf-pmi2"

echo "MSA: PF-PMI3"
start_time=$(date +%s)
Rscript verification/verification_msa.R pf-pmi3 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
./admixture.sh "${output_dir}/msa_pf-pmi3"
