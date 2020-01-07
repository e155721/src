source("test/check_score.R")

list.msa2psa <- function(msa.list, s) {
  # Make the word list of all the words.
  #
  # Args:
  #   files: The files path of all the words.
  #
  # Returns:
  #   psa.list: The word list of all the words.
  # Make the similarity matrix.
  psa.list <- list()
  num.msa <- length(msa.list)
  for (i in 1:num.msa) {
    num.reg <- dim(msa.list[[i]])[1]
    comb.reg <- combn(1:num.reg, 2)
    N <- dim(comb.reg)[2]
    psa.list[[i]] <- list()
    
    for (j in 1:N) {
      seq1 <- msa.list[[i]][comb.reg[1, j], , drop=F]
      seq2 <- msa.list[[i]][comb.reg[2, j], , drop=F]
      aln <- rbind(seq1, seq2)
      
      psa.list[[i]][[j]] <- list()
      psa.list[[i]][[j]]$seq1 <- seq1
      psa.list[[i]][[j]]$seq2 <- seq2
      psa.list[[i]][[j]]$aln <- aln
      psa.list[[i]][[j]]$score <- CheckScore(aln, s)
    }
  }
  
  return(psa.list)
}

MultiplePMI <- function(psa.list, input.list, s) {
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
    s <- CalcPMI(psa.list, s)
    # Compute the new PSA using the new scoring matrix.
    psa.list <- MakePSA(input.list, s)
  }
  # END OF LOOP
  
  return(s)
}
