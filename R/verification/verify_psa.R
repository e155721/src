source("lib/load_exec_align.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", "psa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

acc_file <- paste(output_dir, "/", "acc_psa_", method, ".txt", sep = "")

word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

psa_rlt       <- execute_psa(method, word_list, output_dir)
psa_list_gold <- lapply(word_list_gold, make_gold_psa)

if (method == "ld") {
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

# Calculate the PSAs accuracy.
VerificationPSA(psa_list, psa_list_gold, acc_file, output_dir)

# Output the PSAs.
output_psa(psa_list, output_dir = output_dir, ext = ".csv")
output_psa(psa_list_gold, output_dir = output_dir, ext = "_lg.csv")
