#!/bin/zsh

OUT="/dev/zero"

input_dir="../../Alignment/ryukyuan/"
#input_dir="../../Alignment/bulgarian/"
output_dir=$(Rscript scripts/make_output_dir.R | tail -n1 | cut -f2 -d" ")
echo $output_dir

echo "PSA: LD"
start_time=$(date +%s)
Rscript verification/verification_psa.R ld $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: LD2"
start_time=$(date +%s)
Rscript verification/verification_psa.R ld2 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: PMI"
start_time=$(date +%s)
Rscript verification/verification_psa.R pmi $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: PF-PMI0"
start_time=$(date +%s)
Rscript verification/verification_psa.R pf-pmi0 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: PF-PMI1"
start_time=$(date +%s)
Rscript verification/verification_psa.R pf-pmi1 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: PF-PMI2"
start_time=$(date +%s)
Rscript verification/verification_psa.R pf-pmi2 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""

echo "PSA: PF-PMI3"
start_time=$(date +%s)
Rscript verification/verification_psa.R pf-pmi3 $input_dir $output_dir T
end_time=$(date +%s)
echo "Time:" $((end_time - start_time))
echo ""
