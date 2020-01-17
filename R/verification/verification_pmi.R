source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("psa/pairwise_pmi.R")
source("verification/VerificationPSA.R")

file <- "ansrate_pmi"
dir <- "pairwise_pmi"

# Set the path of the matching rate.
ansrate.file <- paste("../../Alignment/", file, "_", format(Sys.Date()), ".txt", sep = "")

# Set the path of the PSA directory.
output.dir <- paste("../../Alignment/", dir, "_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# Update the scoring matrix with PMI.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforAllWords(list.words, s)
s <- PairwisePMI(psa.list, s)
#save(s, file=paste("scoring_matrix_pmi_", format(Sys.Date()), ".RData", sep=""))

# Execute the PSA for each word.
VerificationPSA(ansrate.file, output.dir, s)
