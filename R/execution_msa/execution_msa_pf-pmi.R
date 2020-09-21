source("msa/msa_pf-pmi.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

msa_list <- msa_pf_pmi(word_list)$msa_list

OutputMSA(msa_list, file_list, output_dir)
