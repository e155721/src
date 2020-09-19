source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_pmi.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("lib/load_exec_align.R")
source("verification_multiple/change_list_msa2psa.R")
source("verification_multiple/CalcAccMSA.R")
source("verification_multiple/msa_tools.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pmi"
multiple <- "multiple_pmi"
ext = commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

cv_sep <- F  # CV-separation

# Compute the scoring matrix using the PMI method.
word_list <- make_word_list()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(word_list, s, dist = T)
s <- PairwisePMI(psa.list, word_list, s, UpdatePMI, cv_sep)$s
#save(s, file="scoring_matrix_msa_pmi.RData")

N <- length(s)
s.old.main <- s
s.old.main <- apply(s.old.main, MARGIN = c(1, 2), zero)

loop <- 0
while (1) {
  print("First loop")
  diff <- N - sum(s == s.old.main)
  if (diff == 0) {
    break
  } else {
    s.old.main <- s
  }

  if (loop == 10) {
    print("MAX LOOP!!")
    break
  } else {
    loop <- loop + 1
  }

  # For progressive
  print("PA loop")
  pa.o <- msa_loop(word_list, s, pa = T, msa_list = NULL, method = UpdatePMI, cv_sep = cv_sep)

  pa_list <- pa.o$msa_list
  s       <- pa.o$s

  # For best first
  print("BF loop")
  msa.o <- msa_loop(word_list, s, pa = F, msa_list = pa_list, method = UpdatePMI, cv_sep = cv_sep)

  msa_list <- msa.o$msa_list
  s        <- msa.o$s

}
pmi.mat <- msa.o$pmi.mat

# Calculate the accuracy of the MSAs.
CalcAccMSA(msa_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata.path <- MakeMatPath("matrix_msa_pmi", "score_msa_pmi", ext)
save(pmi.mat, file = rdata.path$rdata1)
save(s, file = rdata.path$rdata2)
