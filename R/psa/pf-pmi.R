source("lib/load_phoneme.R")

sym2feat <- function(x) {
  return(mat.CV.feat[x, ])
}

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
  corpus <- MakeCorpus(psa.list)
  corpus <- corpus[, -which(corpus[1, ] == "-"), drop=F]
  corpus <- corpus[, -which(corpus[2, ] == "-"), drop=F]
  
  ### Convert the symbols to features ###
  num.CV.feat <- length(CV.feat)
  feat.mat <- matrix(NA, num.CV.feat, num.CV.feat, dimnames=list(CV.feat, CV.feat))
  dimnames(mat.CV.feat) <- list(c(C, V), NULL)
  
  corpus.feat <- t(apply(corpus, 1, sym2feat))
  
  # Compute the PMI for each pair.
  feat <- unique(as.vector(corpus.feat))
  feat <- permutations(length(feat), 2, v=feat, repeats.allowed=T)
  num.feat.pair <- dim(feat)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:num.feat.pair) %dopar% {
    score.vec$V1 <- feat[i, 1]
    score.vec$V2 <- feat[i, 2]
    score.vec$pmi <- PMI(feat[i, 1], feat[i, 2], corpus.feat, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:num.feat.pair, .combine = c) %dopar%
    pmi.list[[i]]$pmi
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  for (i in 1:num.feat.pair)
    feat.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
  
  # Convert the PMI to the weight of edit operations.
  sym <- unique(as.vector(corpus))
  for (i in sym)
    for (j in sym)
      s[i, j] <- sum(diag(feat.mat[mat.CV.feat[i, ], mat.CV.feat[j, ]]))
  
  s[C, V] <- -Inf
  s[V, C] <- -Inf
  
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
