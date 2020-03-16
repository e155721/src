source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("psa/pairwise_pmi.R")
source("psa/pairwise_pf-pmi.R")
source("psa/psa_for_each_word.R")
source("verification_multiple/change_list_msa2psa.R")
source("verification_multiple/CalcAccMSA.R")
source("parallel_config.R")

ansrate <- "ansrate_msa_pf-pmi"
multiple <- "multiple_pf-pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Compute the scoring matrix using the PMI method.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(list.words, s, dist = T)
s <- PairwisePFPMI(psa.list, list.words, s)$s
#save(s, file="scoring_matrix_msa_pmi.RData")

s.old.main <- s
N <- length(s.old.main)
for (i in 1:N) {
  s.old.main <- 0 
}

while (1) {
  print("First loop")
  diff <- N - sum(s == s.old.main)
  if (diff == 0) break
  
  # For progressive
  s.old <- s
  for (i in 1:N) {
    s.old[i] <- 0
  }
  
  pa.list <- list()
  while (1) {
    print("Second loop")
    diff <- N - sum(s == s.old)
    if (diff == 0) break
    #
    for (w in list.words) {
      # Make the word list.
      gold.list <- MakeWordList(w["input"])  # gold alignment
      seq.list <- MakeInputSeq(gold.list)  # input sequences
      
      # Computes the MSA using the BestFirst method.
      print(paste("Start:", w["name"]))
      id <- as.numeric(w["id"])
      pa.list[[id]] <- list()
      pa.list[[id]] <- ProgressiveAlignment(seq.list, s, F)
      print(paste("End:", w["name"]))
    } 
    #
    psa.list <- ChangeListMSA2PSA(pa.list, s)
    s.old <- s
    s <- PairwisePFPMI(psa.list, list.words, s)$s
  }
  
  # For best first
  s.old <- s
  for (i in 1:N) {
    s.old[i] <- 0
  }
  
  msa.list <- list()
  while (1) {
    print("Third loop")
    diff <- N - sum(s == s.old)
    if (diff == 0) break
    #
    for (w in list.words) {
      # Make the word list.
      gold.list <- MakeWordList(w["input"])  # gold alignment
      seq.list <- MakeInputSeq(gold.list)  # input sequences
      
      # Computes the MSA using the BestFirst method.
      id <- as.numeric(w["id"])
      msa.list[[id]] <- list()
      msa.list[[id]] <- BestFirst(pa.list[[id]], s, F)
    }
    #
    psa.list <- ChangeListMSA2PSA(msa.list, s)
    s.old <- s
    s <- PairwisePFPMI(psa.list, list.words, s)$s
  }
  s.old.main <- s
}

# Calculate the accuracy of the MSAs.
CalcAccMSA(msa.list, list.words, path$ansrate.file, path$output.dir)
save(s, file = "score_PF-PMI.RData")
