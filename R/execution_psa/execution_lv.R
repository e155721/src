source("psa/psa_lv.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

# Execute the PSA for each word.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

psa_list <- psa_lv(word_list)

OutputPSA(psa_list, file_list, output_dir)
