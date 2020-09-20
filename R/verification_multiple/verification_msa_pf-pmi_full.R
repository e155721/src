source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_pmi.R")
source("lib/load_msa.R")
source("lib/load_exec_align.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pf-pmi"
multiple <- "multiple_pf-pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

cv_sep <- F  # CV-separation

# Compute the scoring matrix using the PMI method.
file_list <- GetPathList()
word_list <- make_word_list(file_list)
s <- MakeEditDistance(Inf)
psa_list <- PSAforEachWord(word_list, s, dist = T)
s <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI, cv_sep)$s

msa_pmi <- MultiplePMI(word_list, s, UpdatePFPMI)

msa_list <- msa_pmi$msa_list
pmi_mat <- msa_pmi$pmi.mat
s <- msa_pmi$s

# Calculate the accuracy of the MSAs.
verification_msa(msa_list, file_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("matrix_msa_pf-pmi", "score_msa_pf-pmi", ext)
save(pmi_mat, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
