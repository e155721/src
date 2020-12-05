source("msa/msa_lv.R")
source("lib/load_data_processing.R")


input_file <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", sep = "")

# Get the all of files path.
word_list <- make_word_list(input_file)

# Execute the PSA.
msa_list <- msa_lv(word_list)

# Output the PSA.
OutputMSA(msa_list, word_list, output_dir)
