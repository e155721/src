source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_pmi.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

cv_sep <- F  # CV-separation

# Compute the scoring matrix using the PMI method.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)
s <- MakeEditDistance(Inf)
psa_list <- PSAforEachWord(word_list, s, dist = T)
s <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI, cv_sep)$s

msa_pmi <- MultiplePMI(word_list, s, UpdatePFPMI)

msa_list <- msa_pmi$msa_list
pmi_mat <- msa_pmi$pmi_mat
s <- msa_pmi$s

OutputMSA(msa_list, file_list, output_dir)

# Save the matrix of the PMIs and the scoring matrix.
save(pmi_mat, file = paste(output_dir, "matrix_msa_pf-pmi.RData", sep = ""))
save(s, file = paste(output_dir, "score_msa_pf-pmi.RData", sep = ""))
