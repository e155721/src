source("msa/msa_pf-pmi.R")
source("lib/load_data_processing.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

# Execute the PSA.
pf_pmi_rlt   <- msa_pf_pmi(word_list, cv_sep = T)
msa_list     <- pf_pmi_rlt$msa_list
score_pf_pmi <- pf_pmi_rlt$s

# Output the PSA.
OutputMSA(msa_list, file_list, output_dir)

# Output the updated scoring matrix.
save(score_pf_pmi, file = paste(output_dir, "msa_pf-pmi_score_mat.RData", sep = ""))
