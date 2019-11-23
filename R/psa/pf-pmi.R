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
  # Removes identical segments from the corpus.
  #corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  corpus <- corpus[, -which(corpus[1, ] == "-"), drop=F]
  corpus <- corpus[, -which(corpus[2, ] == "-"), drop=F]
  
  ### Convert the symbols to features ###
  C <- as.vector(read.table("lib/data/symbols/consonants")[, 1])
  num.C <- length(C)
  
  V <- as.vector(read.table("lib/data/symbols/vowels")[, 1])
  num.V <- length(V)
  
  C.feat <- as.matrix(read.table("lib/data/features/consonants_values"))
  V.feat <- as.matrix(read.table("lib/data/features/vowels_values"))
  
  for (j in 1:5) {
    C.feat[, j] <- paste("C", C.feat[, j], j, sep="")
    V.feat[, j] <- paste("V", V.feat[, j], j, sep="")
  }
  CV.feat <- rbind(C.feat, V.feat)
  dimnames(CV.feat) <- list(c(C, V), NULL)
  
  kind.C.feat <- unique(as.vector(C.feat))
  kind.V.feat <- unique(as.vector(V.feat))
  kind.CV.feat <- c(kind.C.feat, kind.V.feat)
  num.kind.CV.feat <- length(kind.CV.feat)
  feat.mat <- matrix(NA, num.kind.CV.feat, num.kind.CV.feat, dimnames=list(kind.CV.feat, kind.CV.feat))
  
  len <- dim(corpus)[2]
  seq1 <- NULL
  seq2 <- NULL
  for (i in 1:len) {
    seq1 <- c(seq1, CV.feat[corpus[1, i], ])
    seq2 <- c(seq2, CV.feat[corpus[2, i], ])
  }
  corpus.feat <- rbind(seq1, seq2)
  #######################################
  
  # Compute the PMI for each pair.
  sym <- unique(as.vector(corpus))
  corpus <- corpus.feat
  feat <- unique(as.vector(corpus))
  feat <- permutations(length(feat), 2, v=feat, repeats.allowed=T)
  len <- dim(feat)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.vec$V1 <- feat[i, 1]
    score.vec$V2 <- feat[i, 2]
    #score.vec$pmi <- -PMI(feat[i, 1], feat[i, 2], corpus, E)
    score.vec$pmi <- PMI(feat[i, 1], feat[i, 2], corpus, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:len, .combine = c) %dopar%
    pmi.list[[i]]$pmi
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  for (i in 1:len)
    feat.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
  
  # Convert the PMI to the weight of edit operations.
  for (i in sym)
    for (j in sym)
      s[i, j] <- sum(diag(feat.mat[CV.feat[i, ], CV.feat[j, ]]))
  
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