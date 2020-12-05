source("psa/psa_pmi.R")
source("lib/load_data_processing.R")


input_file  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", sep = "")

word_list <- make_word_list(input_file)

# Execute the PSA.
pmi_rlt   <- psa_pmi(word_list, cv_sep = T)
psa_list  <- pmi_rlt$psa_list
score_pmi <- pmi_rlt$s

# Output the PSA.
OutputPSA(psa_list, word_list, output_dir)

# Output the updated scoring matrix.
save(score_pmi, file = paste(output_dir, "psa_pmi_score_mat.RData", sep = ""))
