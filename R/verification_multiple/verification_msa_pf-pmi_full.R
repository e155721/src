source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("psa/pf-pmi.R")
source("psa/pairwise_pmi.R")
source("lib/load_exec_align.R")
source("verification_multiple/change_list_msa2psa.R")
source("verification_multiple/CalcAccMSA.R")
source("verification_multiple/msa_tools.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pf-pmi"
multiple <- "multiple_pf-pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Compute the scoring matrix using the PMI method.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(list.words, s, dist = T)
s <- PairwisePMI(psa.list, list.words, s, UpdatePFPMI, cv_sep = F)$s
#save(s, file="scoring_matrix_msa_pmi.RData")

N <- length(s)
s.old.main <- s
s.old.main <- apply(s.old.main, MARGIN = c(1, 2), zero)

while (1) {
  print("Main loop")
  diff <- N - sum(s == s.old.main)
  if (diff == 0) {
    break
  } else {
    s.old.main <- s
  }

  # For progressive
  print("PA loop")
  pa.o <- msa_loop(list.words, s, pa = T, method = UpdatePFPMI)

  pa_list <- pa.o$msa_list
  s       <- pa.o$s

  # For best first
  print("BF loop")
  msa.o <- msa_loop(list.words, s, pa = F, pa_list, method = UpdatePFPMI)

  msa_list <- msa.o$msa_list
  s        <- msa.o$s

}
pmi.mat <- msa.o$pmi.mat

# Calculate the accuracy of the MSAs.
CalcAccMSA(msa_list, list.words, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata.path <- MakeMatPath("matrix_msa_pf-pmi", "score_msa_pf-pmi", ext)
save(pmi.mat, file = rdata.path$rdata1)
save(s, file = rdata.path$rdata2)
