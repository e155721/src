source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("psa/psa_for_each_word.R")
source("lib/load_verif_lib.R")
source("psa/pmi.R")
source("psa/pairwise_pmi.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_pmi"
dir <- "pairwise_pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(file, dir, ext)

# Create an itnitial scoring matrix and a list of PSAs.
list.words <- GetPathList()
s          <- MakeEditDistance(Inf)
psa.list   <- PSAforEachWord(list.words, s, dist = T)

# Update the scoring matrix using the PMI.
pmi.o    <- PairwisePMI(psa.list, list.words, s, UpdatePMI)
pmi.mat  <- pmi.o$pmi.mat
s        <- pmi.o$s
psa.list <- pmi.o$psa.list

# Execute the PSA for each word.
VerificationPSA(psa.list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
if (is.na(ext)) {
  ext <- NULL 
} else {
  ext <- paste("_", ext, sep = "")
}
save(pmi.mat, file = paste("matrix_psa_pmi", ext, "_", format(Sys.Date()), ".RData", sep = ""))
save(s, file = paste("score_psa_pmi", ext, "_", format(Sys.Date()), ".RData", sep = ""))
