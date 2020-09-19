source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_pmi.R")
source("lib/load_msa.R")
source("lib/load_exec_align.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pmi"
multiple <- "multiple_pmi"
ext = commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

cv_sep <- F  # CV-separation

# Compute the scoring matrix using the PMI method.
word_list <- make_word_list()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(word_list, s, dist = T)
s <- PairwisePMI(psa.list, word_list, s, UpdatePMI, cv_sep)$s
#save(s, file="scoring_matrix_msa_pmi.RData")

msa_pmi <- MultiplePMI(word_list, s, UpdatePMI)

msa_list <- msa_pmi$msa_list
pmi.mat <- msa_pmi$pmi.mat
s <- msa_pmi$s

# Calculate the accuracy of the MSAs.
verification_msa(msa_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata.path <- MakeMatPath("matrix_msa_pmi", "score_msa_pmi", ext)
save(pmi.mat, file = rdata.path$rdata1)
save(s, file = rdata.path$rdata2)
