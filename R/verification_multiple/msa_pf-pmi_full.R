source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("msa/BestFirst.R")
source("psa/pmi.R")
source("psa/pf-pmi.R")
source("verification_multiple/VerificationMSA.R")
source("verification_multiple/change_list_msa2psa.R")
source("verification_multiple/msa_set.R")

source("msa/BestFirst2.R")
source("msa/ProgressiveAlignment2.R")

############################################################
MakeListPFPMIMSA <- function(s.list, similarity=F) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.
  
  # Get the all of files path.
  files <- GetPathList()
  accuracy.mat <- matrix(NA, length(files), 2)
  msa.list <- list()
  
  i <- 1
  for (file in files) {
    
    # Make the word list.
    gold.list <- MakeWordList(file["input"])  # gold alignment
    psa.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Computes the MSA using the BestFirst method.
    print(paste("Start:", file["name"]))
    psa.init <- ProgressiveAlignment2(psa.list, s.list, similarity)
    msa.list[[i]] <- list()
    msa.list[[i]] <- BestFirst2(psa.init, s.list, similarity)
    i <- i + 1
    print(paste("End:", file["name"]))
    
  }
  
  return(msa.list)
}

MultiplePFPMI <- function(psa.list, input.list, s, p) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  # Compute the initial PSA.
  
  as <- 0 
  # START OF LOOP
  while(1) {
    # Update the old scoring matrix and the alignment.
    as.new <- 0
    M <- length(psa.list)
    for (i in 1:M) {
      N <- length(psa.list[[i]])
      for (j in 1:N) 
        as.new <- as.new + psa.list[[i]][[j]]$score
    }
    print(paste("Old Edit Distance:", as))
    print(paste("New Edit Distance:", as.new))
    
    # Check the convergence of the PMI.
    if (as == as.new) {
      break
    } else {
      as <- as.new
    }
    
    # Compute the new scoring matrix that is updated by the PMI-weighting.
    s <- CalcPFPMI(psa.list, s, p)
    # Compute the new PSA using the new scoring matrix.
    psa.list <- MakePSA(input.list, s)
  }
  # END OF LOOP
  
  return(s)
}
############################################################

ansrate <- "ansrate_msa"
multiple <- "multiple"

for (pf in 1:5) {
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/", ansrate, "_pf-pmi_pf", pf, "_", format(Sys.Date()), ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/", multiple, "_pf-pmi_pf", pf, "_", format(Sys.Date()), "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # Compute the scoring matrix using the PF-PMI method.
  files <- GetPathList()
  input.list <- MakeInputList(files)
  s.list <- list()
  for (p in pf) {
    s <- MakeEditDistance(Inf)
    s.list[[p]] <- PairwisePFPMI(input.list, s, p)
  }
  s.len <- length(s.list)
  
  s.old <- s.list
  for (p in 1:s.len) {
    N <- length(s.old[[p]])
    for (i in 1:N) {
      s.old[[p]][i] <- 0
    }
  }
  
  while (1) {
    diff <- NULL
    for (p in 1:s.len) {
      diff[p] <- N - sum(s.list[[p]] == s.old[[p]])
    }
    diff <- sum(diff)
    if (diff == 0) break
    msa.list <- MakeListPFPMIMSA(s.list, similarity=F)
    psa.list <- ChangeListMSA2PSA(msa.list, MakeEditDistance(Inf))
    s.old <- s.list
    for (p in 1:s.len) {
      s.list[[p]] <- MultiplePFPMI(psa.list, input.list, s.list[[p]], p)
    }
  }
  VerificationMSA(ansrate.file, output.dir, msa.list)
}
