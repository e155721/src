source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("psa/pairwise_pmi.R")
source("psa/pairwise_pf-pmi.R")
source("verification/VerificationPSA.R")
source("parallel_config.R")

file <- "ansrate_pf-pmi"
dir <- "pairwise_pf-pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(file, dir, ext)

# Update the scoring matrix with PMI.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(list.words, s)
s <- PairwisePFPMI(psa.list, list.words, s)
#save(s, file=paste("scoring_matrix_pmi_", format(Sys.Date()), ".RData", sep=""))

# Execute the PSA for each word.
VerificationPSA(path$ansrate.file, path$output.dir, s)
