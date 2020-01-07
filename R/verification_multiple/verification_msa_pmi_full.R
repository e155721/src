source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("msa/BestFirst.R")
source("psa/pmi.R")
source("verification_multiple/VerificationMSA.R")
source("verification_multiple/pmi_for_msa.R")
source("verification_multiple/msa_set.R")

ansrate <- "ansrate_msa"
multiple <- "multiple"

# matchingrate path
ansrate.file <- paste("../../Alignment/", ansrate, "_pmi_", format(Sys.Date()), ".txt", sep = "")

# result path
output.dir <- paste("../../Alignment/", multiple, "_pmi_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# Compute the scoring matrix using the PMI method.
files <- GetPathList()
input.list <- MakeInputList(files)
s <- MakeEditDistance(Inf)
s <- PairwisePMI(input.list, s)
#save(s, file="scoring_matrix_msa_pmi.RData")

s.old <- s
N <- length(s.old)
for (i in 1:N) {
  s.old[i] <- 0
}

while (1) {
  diff <- N - sum(s == s.old)
  if (diff == 0) break
  msa.list <- MakeListMSA(s, similarity=F)
  psa.list <- list.msa2psa(msa.list, s)
  s.old <- s
  s <- MultiplePMI(psa.list, input.list, s)
  VerificationMSA(ansrate.file, output.dir, msa.list)
}
VerificationMSA(ansrate.file, output.dir, msa.list)
