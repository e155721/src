source("msa/msa_lv.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

# Get the all of files path.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
msa_list <- msa_lv(word_list)

# Output the PSA.
OutputMSA(msa_list, file_list, output_dir)
