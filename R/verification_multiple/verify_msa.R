source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", "msa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

acc_file <- paste(output_dir, "/", "acc_msa_", method, ".txt", sep = "")

word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

msa_list      <- execute_msa(method, word_list, output_dir)
msa_list_gold <- lapply(word_list_gold, make_gold_msa)

# Calculate the MSAs accuracy.
verification_msa(msa_list, msa_list_gold, acc_file, output_dir)

# Output the PSAs.
output_msa(msa_list, output_dir, ext = ".csv")
output_msa(msa_list_gold, output_dir, ext = "_lg.csv")
