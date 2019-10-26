source("lib/load_data_processing.R")
source("verification/VerificationGap.R")

# get the all of files path
filesPath <- GetPathList()

ansrate <- "ansrate_pf-pmi"
pairwise <- "pairwise_pf-pmi"

VerificationGap(ansrate=ansrate, pairwise=pairwise, pen=-12)
