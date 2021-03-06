source("lib/load_exec_align.R")
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

output_dir <- paste(output_dir, "/", "psa_", method, ext_name, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

acc_file <- paste(output_dir, "/", "acc_psa_", method, ext_name, ".txt", sep = "")

word_list      <- make_word_list(paste(input_dir, "input.csv", sep = "/"))
word_list_gold <- make_word_list(paste(input_dir, "gold.csv", sep = "/"))

psa_rlt       <- execute_psa(method, word_list, output_dir, cv_sep)
psa_list_gold <- lapply(word_list_gold, make_gold_psa)

if ((method == "ld") || (method == "ld2")) {
  s        <- psa_rlt$s
  psa_list <- psa_rlt$psa_list
} else {
  pmi_list <- psa_rlt$pmi_list
  s        <- psa_rlt$s
  psa_list <- psa_rlt$psa_list

  # Save the matrix of the PMIs and the scoring matrix.
  save(pmi_list, file = paste(output_dir, "/", "list_psa_", method, ".RData", sep = ""))
  save(s, file = paste(output_dir, "/", "score_psa_", method, ".RData", sep = ""))
}

output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

# Calculate the PSAs accuracy.
verify_psa(psa_list, psa_list_gold, acc_file, output_dir_aln)

# Output the PSAs.
output_psa(psa_list, output_dir = output_dir_aln, ext = ".csv")
output_psa(psa_list_gold, output_dir = output_dir_aln, ext = "_lg.csv")

save(psa_list, file = paste(output_dir_aln, "psa_", method, ".RData", sep = ""))
save(psa_list_gold, file = paste(output_dir_aln, "psa_", method, "_lg.RData", sep = ""))

# Plot the phylogenetic trees and the networks.
phylo_each_word(psa_list, output_dir, method, s)

# Calculate the regional distance matrix.
phylo_all_word(word_list, method, s, output_dir)
