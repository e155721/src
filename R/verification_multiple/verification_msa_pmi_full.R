source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("msa/BestFirst.R")
source("psa/pairwise_pmi.R")
source("verification_multiple/pmi_for_msa.R")
source("verification_multiple/VerificationMSA.R")

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
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforAllWords(list.words, s)
s <- PairwisePMI(psa.list, list.words, s)
#save(s, file="scoring_matrix_msa_pmi.RData")

s.old <- s
N <- length(s.old)
for (i in 1:N) {
  s.old[i] <- 0
}

while (1) {
  diff <- N - sum(s == s.old)
  if (diff == 0) break
  msa.list <- MSAforEachWord(list.word, s, similarity=F)
  psa.list <- list.msa2psa(msa.list, s)
  s.old <- s
  s <- PairwisePMI(psa.list, list.words, s)
}
VerificationMSA(ansrate.file, output.dir, s, similarity=F)
