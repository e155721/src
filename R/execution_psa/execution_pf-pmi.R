source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_pmi.R")
source("parallel_config.R")

input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

# Create an itnitial scoring matrix and a list of PSAs.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)
s          <- MakeEditDistance(Inf)
psa_list   <- PSAforEachWord(word_list, s, dist = T)

# Update the scoring matrix using the PF-PMI.
pmi_rlt  <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI)
pmi_mat  <- pmi_rlt$pmi.mat
s        <- pmi_rlt$s
psa_list <- pmi_rlt$psa.list

# Execute the PSA for each word.
OutputPSA(psa_list, file_list, output_dir)

# Save the matrix of the PMIs and the scoring matrix.
save(pmi_mat, file = paste(output_dir, "pf-pmi_mat.RData", sep = ""))
save(s, file = paste(output_dir, "scoring_mat.RData", sep = ""))
