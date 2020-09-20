source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("lib/load_pmi.R")
source("parallel_config.R")

input.dir  <- commandArgs(trailingOnly = TRUE)[1]
output.dir <- commandArgs(trailingOnly = TRUE)[2]

input.dir  <- paste(input.dir, "/", sep = "")
output.dir <- paste(output.dir, "/", sep = "")

# Create an itnitial scoring matrix and a list of PSAs.
file_list <- GetPathList(input.dir)
word_list <- make_word_list(file_list)
s         <- MakeEditDistance(Inf)
psa.list  <- PSAforEachWord(word_list, s, dist = T)

# Update the scoring matrix using the PMI.
pmi.o    <- PairwisePMI(psa.list, word_list, s, UpdatePMI)
pmi.mat  <- pmi.o$pmi.mat
s        <- pmi.o$s
psa.list <- pmi.o$psa.list

# Execute the PSA for each word.
OutputPSA(psa.list, file_list, output.dir)

# Save the matrix of the PMIs and the scoring matrix.
save(pmi.mat, file = paste(output.dir, "pmi_mat.RData", sep = ""))
save(s, file = paste(output.dir, "scoring_mat.RData", sep = ""))
