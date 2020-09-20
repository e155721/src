source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("lib/load_pmi.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_pf-pmi"
dir <- "pairwise_pf-pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

# Create an itnitial scoring matrix and a list of PSAs.
file_list <- GetPathList()
word_list <- make_word_list(file_list)
s         <- MakeEditDistance(Inf)
psa_list  <- PSAforEachWord(word_list, s, dist = T)

# Update the scoring matrix using the PF-PMI.
pmi_rlt  <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI, cv_sep = F)
pmi_mat  <- pmi_rlt$pmi.mat
s        <- pmi_rlt$s
psa_list <- pmi_rlt$psa.list

# Execute the PSA for each word.
VerificationPSA(psa_list, file_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("matrix_psa_pf-pmi", "score_psa_pf-pmi", ext)
save(pmi_mat, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
