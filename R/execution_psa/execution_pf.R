source("psa/psa_pf.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]
pen        <- commandArgs(trailingOnly = TRUE)[3]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

if (is.na(pen)) {
  pen <- -1
} else {
  pen <- as.numeric(pen)
}

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)
psa_list <- psa_pf(word_list, pen)
OutputPSA(psa_list, file_list, output_dir)
