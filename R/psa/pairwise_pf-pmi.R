library(gtools)
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
  N1 <- dim(corpus.feat)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  
  V1 <- length(unique(paste(corpus.feat[1, ], corpus.feat[2, ])))  # number of symbol pairs types in the segment pairs
  V2 <- length(unique(as.vector(corpus.feat)))  # number of symbol types in the segments
  
  f.xy <- vector(length=5)
  f.x  <- vector(length=5)
  f.y  <- vector(length=5)
  for (p in 1:5) {
    f.xy[p] <- sum((x[p] == corpus.feat[1, ]) * (y[p] == (corpus.feat[2, ])))  # frequency of xy in the segmentpairs
    f.x[p]  <- sum(x[p] == corpus.feat)  # frequency of x in the segments
    f.y[p]  <- sum(y[p] == corpus.feat)  # frequency of y in the segments
  }
  
  p.xy <- vector(length=5)
  p.x  <- vector(length=5)
  p.y  <- vector(length=5)
  for (p in 1:5) {
    p.xy[p] <- (f.xy[p] + 1) / (N1 + V1)  # probability of the co-occurrence frequency of xy
    p.x[p]  <- (f.x[p] + 1) / (N2 + V2)  # probability of the occurrence frequency of x
    p.y[p]  <- (f.y[p] + 1) / (N2 + V2)  # probability of the occurrence frequency of y
  }
  
  pmi <- t(p.xy) %*% ginv(p.x %*% t(p.y))
  
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
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  }
  
  ### Convert the symbols to features ###
  num.CV.feat <- length(CV.feat) + 1
  gap <- vector(length=5)
  gap[1:5] <- "-"
  mat.CV.feat <- rbind(mat.CV.feat, gap)
  dimnames(mat.CV.feat) <- list(c(C, V, "-"), NULL)
  
  corpus.feat <- t(apply(corpus, 1, sym2feat, mat.CV.feat))
  corpus.feat <- apply(corpus.feat, 2, sort.col)
  
  # Compute the PMI for each pair.
  sym.vec <- unique(as.vector(corpus))
  sym.vec <- t(combn(x=sym.vec, m=2))
  len <- dim(sym.vec)[1]
  pmi.list <- foreach(i = 1:len) %dopar% {
    pmi     <- list()
    pmi$V1  <- sym.vec[i, 1]
    pmi$V2  <- sym.vec[i, 2]
    pmi$pmi <- PFPMI(mat.CV.feat[sym.vec[i, 1], ], mat.CV.feat[sym.vec[i, 2], ], corpus.feat)
    return(pmi)
  }
  
  score.tmp <- foreach(i = 1:len, .combine = c) %dopar% {
    pmi <- pmi.list[[i]]$pmi
    #-sum(abs(pmi))  # L1 norm
    -sqrt(sum(pmi * pmi))  # L2 norm
  }
  pmi.max <- max(score.tmp)
  pmi.min <- min(score.tmp)
  
  # The three-dimensional array to save the PF-PMI for each symbol pairs.
  s.dim <- dim(s)[1]
  s.names <- dimnames(s)[[1]]
  pmi.mat <- array(NA, dim = c(s.dim, s.dim, 5), dimnames = list(s.names, s.names))
  
  for (i in 1:len) {
    # Save the PF-PMI.
    pmi.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2, ] <- pmi.list[[i]]$pmi
    pmi.mat[pmi.list[[i]]$V2, pmi.list[[i]]$V1, ] <- pmi.list[[i]]$pmi
    # Convert the PMI to the weight of edit operations.
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
    s[pmi.list[[i]]$V2, pmi.list[[i]]$V1] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
  }

  # Prevent pairs of CV.
  pmi.mat[C, V, ] <- NA
  pmi.mat[V, C, ] <- NA
  
  s[C, V] <- Inf
  s[V, C] <- Inf
  
  pmi <- list()
  pmi$pmi.mat <- pmi.mat
  pmi$s <- s
  return(pmi)
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
    rlt.pmi <- CalcPFPMI(psa.list, s)
    pmi.mat <- rlt.pmi$pmi.mat
    s <- rlt.pmi$s
    # Compute the new PSA using the new scoring matrix.
    psa.list <- PSAforEachWord(list.words, s, dist = T)
  }
  # END OF LOOP
  
  pmi <- list()
  pmi$psa.list <- psa.list
  pmi$pmi.mat <- pmi.mat
  pmi$s <- s
  return(pmi)
}
