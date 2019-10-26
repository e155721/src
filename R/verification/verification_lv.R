source("lib/load_data_processing.R")
source("verification/VerificationPSA.R")

# get the all of files path
filesPath <- GetPathList()

ansrate <- "ansrate_lv"
pairwise <- "pairwise_lv"

VerificationPSA(ansrate=ansrate, pairwise=pairwise, method="LV")