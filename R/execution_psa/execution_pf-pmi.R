source("psa/psa_pf-pmi.R")
source("lib/load_data_processing.R")


input_file  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

output_dir <- paste(output_dir, "/", sep = "")

word_list <- make_word_list(input_file)

# Execute the PSA.
pf_pmi_rlt   <- psa_pf_pmi(word_list, cv_sep = T)
psa_list     <- pf_pmi_rlt$psa_list
score_pf_pmi <- pf_pmi_rlt$s

# Output the PSA.
OutputPSA(psa_list, word_list, output_dir)

# Output the updated scoring matrix.
save(score_pf_pmi, file = paste(output_dir, "psa_pf-pmi_score_mat.RData", sep = ""))
