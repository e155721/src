source("lib/load_data_processing.R")
source("verification/VerificationPSA.R")

# get the all of files path
filesPath <- GetPathList()

ansrate <- "ansrate_pf"
pairwise <- "pairwise_pf"

VerificationPSA(ansrate=ansrate, pairwise=pairwise, method="PF", pen=-3)
