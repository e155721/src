source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_dir  <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]
ext_name   <- commandArgs(trailingOnly = TRUE)[5]

if (is.na(ext_name)) {
  ext_name <- NULL
} else {
  ext_name <- paste("_", ext_name, sep = "")
}

output_dir <- paste(output_dir, "/", "msa_", method, ext_name, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

acc_file <- paste(output_dir, "/", "acc_msa_", method, ext_name, ".txt", sep = "")

word_list      <- make_word_list(paste(input_dir, "input.csv", sep = "/"))
word_list_gold <- make_word_list(paste(input_dir, "gold.csv", sep = "/"))

msa_rlt       <- execute_msa(method, word_list, output_dir, cv_sep)
msa_list_gold <- lapply(word_list_gold, make_gold_msa)

if ((method == "ld") || (method == "ld2")) {
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

output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

# Calculate the MSAs accuracy.
verification_msa(msa_list, msa_list_gold, acc_file, output_dir_aln)

# Output the PSAs.
output_msa(msa_list, output_dir_aln, ext = ".csv")
output_msa(msa_list_gold, output_dir_aln, ext = "_lg.csv")

save(msa_list, file = paste(output_dir_aln, "msa_", method, ".RData", sep = ""))
save(msa_list_gold, file = paste(output_dir_aln, "msa_", method, "_lg.RData", sep = ""))

# Plot the phylogenetic trees and the networks.
psa_list <- ChangeListMSA2PSA(msa_list, s)
Plot(psa_list, output_dir, method, s)

# Calculate the regional distance matrix.
make_region_dist(word_list, method, s, output_dir)
