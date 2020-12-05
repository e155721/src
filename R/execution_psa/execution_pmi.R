source("psa/psa_pmi.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
pmi_rlt   <- psa_pmi(word_list, cv_sep = T)
psa_list  <- pmi_rlt$psa_list
score_pmi <- pmi_rlt$s

# Output the PSA.
OutputPSA(psa_list, file_list, output_dir)

# Output the updated scoring matrix.
save(score_pmi, file = paste(output_dir, "psa_pmi_score_mat.RData", sep = ""))
