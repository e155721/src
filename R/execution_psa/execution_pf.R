source("psa/psa_pf.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]
pen        <- commandArgs(trailingOnly = TRUE)[3]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

if (is.na(pen)) {
  pen <- -1  # the default gap penalty
} else {
  pen <- as.numeric(pen)  # the user gap penalty
}

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
psa_list <- psa_pf(word_list, pen)

# Output the PSA.
OutputPSA(psa_list, file_list, output_dir)
