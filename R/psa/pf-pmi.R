CalcPFPMI <- function(psa.list, s) {
  # Compute the PMI of the PSA list.
  #
  # Args:
  #   psa.list: THe PSA list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The scoring matrix that was updated by the PMI-weighting.
  cat("\n")
  print("Calculate PMI")
  
  # Caluculate the PMI.
  newcorpus <- MakeCorpus(psa.list)
  newcorpus <- newcorpus[, -which(newcorpus[1, ] == "-"), drop=F]
  newcorpus <- newcorpus[, -which(newcorpus[2, ] == "-"), drop=F]
  V <- unique(as.vector(newcorpus))
  V <- permutations(length(V), 2, v=V)
  len <- dim(V)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.vec$V1 <- V[i, 1]
    score.vec$V2 <- V[i, 2]
    #score.vec$pmi <- -PMI(V[i, 1], V[i, 2], newcorpus, E)
    score.vec$pmi <- PMI(V[i, 1], V[i, 2], newcorpus, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:len, .combine = c) %dopar%
    pmi.list[[i]]$pmi
  #pmi.max <- max(pmi.tmp)
  #pmi.min <- min(pmi.tmp)
  
  # Convert the PMI to the weight of edit operations.
  for (i in 1:len)
    #s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- pmi.list[[i]]$pmi
  
  s[1:81, 82:118] <- -Inf
  s[82:118, 1:81] <- -Inf
  
  return(s)
}

PairwisePFPMI <- function(input.list, s) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  # Compute the initial PSA.
  psa.list <- MakePSA(input.list, s, dist=F)
  
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
    s <- CalcPFPMI(psa.list, s)
    # Compute the new PSA using the new scoring matrix.
    psa.list <- MakePSA(input.list, s, dist=F)
  }
  # END OF LOOP
  
  return(s)
}