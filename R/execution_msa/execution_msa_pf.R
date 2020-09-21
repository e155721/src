source("msa/msa_pf.R")
source("lib/load_data_processing.R")
source("parallel_config.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]
pen        <- commandArgs(trailingOnly = TRUE)[3]

if (is.na(pen)) {
  pen <- -1  # the default gap penalty
} else {
  pen <- as.numeric(pen)  # the user gap penalty
}

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
msa_list <- msa_pf(word_list, pen)

# Output the PSA.
OutputMSA(msa_list, file_list, output_dir)
