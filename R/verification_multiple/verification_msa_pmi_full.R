source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("psa/pairwise_pmi.R")
source("verification_multiple/change_list_msa2psa.R")
source("verification_multiple/VerificationMSA.R")
source("parallel_config.R")

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
psa.list <- PSAforEachWord(list.words, s)
s <- PairwisePMI(psa.list, list.words, s)
#save(s, file="scoring_matrix_msa_pmi.RData")

# For progressive
s.old <- s
N <- length(s.old)
for (i in 1:N) {
  s.old[i] <- 0
}

pa.list <- list()
while (1) {
  diff <- N - sum(s == s.old)
  if (diff == 0) break
  #
  i <- 1
  for (w in list.words) {
    # Make the word list.
    gold.list <- MakeWordList(w["input"])  # gold alignment
    seq.list <- MakeInputSeq(gold.list)  # input sequences
    
    # Computes the MSA using the BestFirst method.
    print(paste("Start:", w["name"]))
    pa.list[[i]] <- list()
    pa.list[[i]] <- ProgressiveAlignment(seq.list, s, F)
    i <- i + 1
    print(paste("End:", w["name"]))
  } 
  #
  psa.list <- ChangeListMSA2PSA(pa.list, s)
  s.old <- s
  s <- PairwisePMI(psa.list, list.words, s)
}

# For best first
s.old <- s
N <- length(s.old)
for (i in 1:N) {
  s.old[i] <- 0
}

msa.list <- list()
while (1) {
  diff <- N - sum(s == s.old)
  if (diff == 0) break
  #
  i <- 1
  for (pa in pa.list) {
    # Make the word list.
    gold.list <- MakeWordList(w["input"])  # gold alignment
    seq.list <- MakeInputSeq(gold.list)  # input sequences
    
    # Computes the MSA using the BestFirst method.
    msa.list[[i]] <- list()
    msa.list[[i]] <- msa.list[[i]] <- BestFirst(pa, s, F)
    #
    i <- i + 1
  } 
  #
  psa.list <- ChangeListMSA2PSA(msa.list, s)
  s.old <- s
  s <- PairwisePMI(psa.list, list.words, s)
}

# For verification
VerificationMSA(ansrate.file, output.dir, s, similarity=F)
