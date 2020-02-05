library(MASS)

source("lib/load_phoneme.R")

sym2feat <- function(x, args) {
  return(args[x, ])
}

PFPMI <- function(x, y, corpus.feat) {
  # Computes the PMI of symbol pair (x, y) in the corpus.feat.
  # Args:
  #   x, y: The symbols.
  #   corputs: The corpus.feat.
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).
  N1 <- dim(corpus.feat)[2] / 5  # number of the aligned segments
  N2 <- N1 * 2          # number of segments in the aligned segments
  
  V1 <- length(unique(paste(corpus.feat[1, ], corpus.feat[2, ])))  # number of symbol pairs types in the segment pairs
  V2 <- length(unique(as.vector(corpus.feat)))                # number of symbol types in the segments
  
  f.xy <- vector(length=5)
  f.x  <- vector(length=5)
  f.y  <- vector(length=5)
  for (p in 1:5) {
    f.xy[p] <- sum((x[p] == corpus.feat[1, ]) * (y[p] == (corpus.feat[2, ])))  # frequency of xy in the segmentpairs
    f.x[p] <- sum(x[p] == corpus.feat)                                 # frequency of x in the segments
    f.y[p] <- sum(y[p] == corpus.feat)                                 # frequency of y in the segments
  }
  
  p.xy <- vector(length=5)
  p.x  <- vector(length=5)
  p.y  <- vector(length=5)
  for (p in 1:5) {
    p.xy[p] <- (f.xy[p] + 1) / (N1 + V1)   # probability of the co-occurrence frequency of xy
    p.x[p] <- (f.x[p] + 1) / (N2 + V2)     # probability of the occurrence frequency of x
    p.y[p] <- (f.y[p] + 1) / (N2 + V2)     # probability of the occurrence frequency of y
  }
  
  pmi <- t(p.xy) %*% ginv(p.x %*% t(p.y))
  pmi <- sqrt(sum(pmi))
  
  #pmi <- log2(p.xy / (p.x * p.y))  # calculating the pmi
  
  return(pmi)
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
  corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  
  ### Convert the symbols to features ###
  num.CV.feat <- length(CV.feat) + 1
  gap <- vector(length=5)
  gap[1:5] <- "-"
  mat.CV.feat <- rbind(mat.CV.feat, gap)
  dimnames(mat.CV.feat) <- list(c(C, V, "-"), NULL)
  
  #corpus.feat <- t(apply(corpus, 1, sym2feat, mat.CV.feat))
  corpus.feat <- t(apply(corpus, 1, sym2feat, mat.CV.feat))
  
  # Compute the PMI for each pair.
  V <- unique(as.vector(corpus))
  V <- permutations(length(V), 2, v=V)
  len <- dim(V)[1]
  #score.list <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.list <- list()
    score.list$V1  <- V[i, 1]
    score.list$V2  <- V[i, 2]
    score.list$pmi <- -PFPMI(mat.CV.feat[V[i, 1], ], mat.CV.feat[V[i, 2], ], corpus.feat)
    return(score.list)
    #return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:len, .combine = c) %dopar% {
    pmi.list[[i]]$pmi
  }
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  # Convert the PMI to the weight of edit operations.
  for (i in 1:len) {
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
  }
  
  s[1:81, 82:118] <- Inf
  s[82:118, 1:81] <- Inf
  
  return(s)
}

PairwisePFPMI <- function(psa.list, list.words, s) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  s.old <- s
  N <- length(s.old)
  for (i in 1:N) {
    s.old[i] <- 0
  }
  # START OF LOOP
  while(1) {
    diff <- N - sum(s == s.old)
    if (diff == 0) break
    # Compute the new scoring matrix that is updated by the PMI-weighting.
    s.old <- s
    s <- CalcPFPMI(psa.list, s)
    # Compute the new PSA using the new scoring matrix.
    psa.list <- PSAforAllWords(list.words, s)
  }
  # END OF LOOP
  
  return(s)
}

