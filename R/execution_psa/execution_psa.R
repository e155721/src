source("lib/load_exec_align.R")
source("lib/load_data_processing.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_file <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]

output_dir <- paste(output_dir, "/", "psa_", method, "/", sep = "")

# Execute the PSA.
word_list <- make_word_list(input_file)
psa_rlt   <- execute_psa(method, word_list, output_dir, cv_sep)

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

# Output the PSAs.
output_psa(psa_list, output_dir = output_dir, ext = ".csv")
