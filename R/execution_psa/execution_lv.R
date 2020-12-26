source("psa/psa_lv.R")
source("lib/load_data_processing.R")


input_file  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", sep = "")

word_list <- make_word_list(input_file)

# Execute the PSA.
psa_list <- psa_lv(word_list)

# Output the PSA.
output_psa(psa_list, output_dir, ext = ".csv")
