source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_file <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]

output_dir <- paste(output_dir, "/", "msa_", method, "/", sep = "")

# Execute the MSA.
word_list <- make_word_list(input_file)
msa_rlt   <- execute_msa(method, word_list, output_dir, cv_sep)

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

# Output the MSAs.
output_msa(msa_list, output_dir, ext = ".csv")
