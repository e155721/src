source("lib/load_phoneme.R")

sym2feat <- function(x, args) {
  return(args[[1]][x, args[[2]]])
}

CalcPFPMI <- function(psa.list, s, p) {
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
  # Removes identical segments from the corpus.
  #corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  #corpus <- corpus[, -which(corpus[1, ] == "-"), drop=F]
  #corpus <- corpus[, -which(corpus[2, ] == "-"), drop=F]
  
  ### Convert the symbols to features ###
  num.CV.feat <- length(CV.feat) + 1
  feat.mat <- matrix(0, num.CV.feat, num.CV.feat, dimnames=list(c(CV.feat, "-"), c(CV.feat, "-")))
  gap <- vector(length=5)
  gap[1:5] <- "-"
  mat.CV.feat <- rbind(mat.CV.feat, gap)
  dimnames(mat.CV.feat) <- list(c(C, V, "-"), NULL)
  
  #corpus.feat <- t(apply(corpus, 1, sym2feat, mat.CV.feat))
  corpus.feat <- t(apply(corpus, 1, sym2feat, list(mat.CV.feat, p)))
  # Removes identical segments from the corpus.
  corpus.feat <- corpus.feat[, -which(corpus.feat[1, ] == corpus.feat[2, ]), drop=F]
  
  # Compute the PMI for each pair.
  feat <- unique(as.vector(corpus.feat))
  feat <- permutations(length(feat), 2, v=feat, repeats.allowed=F)
  #feat <- feat[-1, ]
  num.feat.pair <- dim(feat)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:num.feat.pair) %dopar% {
    score.vec$V1 <- feat[i, 1]
    score.vec$V2 <- feat[i, 2]
    score.vec$pmi <- -PMI(feat[i, 1], feat[i, 2], corpus.feat, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:num.feat.pair, .combine = c) %dopar%
    pmi.list[[i]]$pmi
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  for (i in 1:num.feat.pair)
    feat.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
  
  feat.mat[C.feat, V.feat] <- Inf
  feat.mat[V.feat, C.feat] <- Inf
  
  # Convert the PMI to the weight of edit operations.
  sym <- unique(as.vector(corpus))
  for (i in sym)
    for (j in sym)
      s[i, j] <- sum(diag(feat.mat[mat.CV.feat[i, ], mat.CV.feat[j, ]]))
  
  s[C, V] <- Inf
  s[V, C] <- Inf
  
  return(s)
}

PairwisePFPMI <- function(input.list, s, p) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  # Compute the initial PSA.
  psa.list <- MakePSA(input.list, s, dist=T)
  
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
    psa.list <- MakePSA(input.list, s, dist=T)
  }
  # END OF LOOP
  
  return(s)
}
