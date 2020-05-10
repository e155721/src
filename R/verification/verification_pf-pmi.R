source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("psa/psa_for_each_word.R")
source("lib/load_verif_lib.R")
source("psa/pairwise_pmi.R")
source("psa/pf-pmi.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_pf-pmi"
dir <- "pairwise_pf-pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(file, dir, ext)

# Update the scoring matrix with PMI.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(list.words, s, dist = T)
psa.list <- PairwisePMI(psa.list, list.words, s, UpdatePFPMI)$psa.list
#save(s, file=paste("scoring_matrix_pmi_", format(Sys.Date()), ".RData", sep=""))

# Execute the PSA for each word.
VerificationPSA(psa.list, path$ansrate.file, path$output.dir)
