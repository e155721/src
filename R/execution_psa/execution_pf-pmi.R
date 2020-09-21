source("psa/psa_pf-pmi.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
psa_list <- psa_pf_pmi(word_list)$psa_list

# Output the PSA.
OutputPSA(psa_list, file_list, output_dir)
