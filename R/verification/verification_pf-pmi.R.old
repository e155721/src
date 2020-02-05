library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_verif_lib.R")
source("psa/pf-pmi.R")
source("psa/pmi.R")
source("verification/VerificationPSA.R")

file <- "ansrate_pf-pmi"
dir <- "pairwise_pf-pmi"

# Set the path of the matching rate.
ansrate.file <- paste("../../Alignment/", file, "_", format(Sys.Date()), ".txt", sep = "")

# Set the path of the PSA directory.
output.dir <- paste("../../Alignment/", dir, "_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir))
  dir.create(output.dir)

# Update the scoring matrix with PMI.
files <- GetPathList()
input.list <- MakeInputList(files)
s.list <- list()
for (p in 1:5) {
  s <- MakeEditDistance(Inf)
  s.list[[p]] <- PairwisePFPMI(input.list, s, p)
  s <- s.list[[p]]
}
save(s.list, file=paste("scoring_matrices_pf-pmi_", format(Sys.Date()), ".RData", sep=""))

# Execute the PSA for each word.
#VerificationPSA(ansrate.file, output.dir, s)
