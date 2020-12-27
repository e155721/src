source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]
cv_sep     <- commandArgs(trailingOnly = TRUE)[3]

output_dir <- paste(output_dir, "/", "msa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

acc_file <- paste(output_dir, "/", "acc_msa_", method, ".txt", sep = "")

word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

msa_rlt       <- execute_msa(method, word_list, output_dir, cv_sep)
msa_list_gold <- lapply(word_list_gold, make_gold_msa)

if (method == "ld") {
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list
} else {
  pmi_list <- msa_rlt$pmi_list
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list

  # Save the matrix of the PMIs and the scoring matrix.
  save(pmi_list, file = paste(output_dir, "/", "list_msa_", method, ".RData", sep = ""))
  save(s, file = paste(output_dir, "/", "score_msa_", method, ".RData", sep = ""))
}

# Calculate the MSAs accuracy.
verification_msa(msa_list, msa_list_gold, acc_file, output_dir)

# Output the PSAs.
output_msa(msa_list, output_dir, ext = ".csv")
output_msa(msa_list_gold, output_dir, ext = "_lg.csv")

# Plot the phylogenetic trees and the networks.
Plot(msa_list, output_dir, method, s)

# Calculate the regional distance matrix.
make_region_dist(output_dir, method, s)
