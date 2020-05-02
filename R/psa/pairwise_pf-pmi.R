library(gtools)
library(MASS)

source("lib/load_phoneme.R")

sym2feat <- function(x, args) {
  return(args[x, ])
}

PFPMI <- function(f.xy, f.x, f.y, corpus.feat) {
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
  seg.vec <- unique(as.vector(corpus))
  seg.num <- length(seg.vec)
  
  feat.vec <- unique(as.vector(corpus.feat))
  feat.num <- length(feat.vec)
  
  seg.pair.mat <- t(combn(x=seg.vec, m=2))
  seg.pair.num <- dim(seg.pair.mat)[1]
  
  feat.pair.mat <- combn(x=feat.vec, m=2)
  feat.pair.mat <- cbind(feat.pair.mat, rbind(feat.vec, feat.vec))  # add the identical feature pairs.
  feat.pair.mat <- t(apply(feat.pair.mat, 2, sort.col))
  feat.pair.num <- dim(feat.pair.mat)[1]
  
  # Calculate the frequency matrix for aligned features.
  feat.pair.freq.mat <- matrix(0, feat.num, feat.num, 
                              dimnames = list(feat.vec, feat.vec))
  for (i in 1:feat.pair.num) {
    x <- feat.pair.mat[i, 1]
    y <- feat.pair.mat[i, 2]
    feat.pair.freq.mat[x, y] <- sum((x == corpus.feat[1, ]) * (y == (corpus.feat[2, ])))  # frequency of xy in the segmentpairs
  }
  
  # Calculate the frequency vector for individual segments.
  feat.freq.vec <- vector(mode = "numeric", feat.num)
  names(feat.freq.vec) <- feat.vec
  for (i in 1:feat.num) {
    x <- feat.vec[i]
    feat.freq.vec[x] <- sum(x == corpus.feat)
  }
  
  pmi.list <- foreach(i = 1:seg.pair.num) %dopar% {
    
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    
    x.feat <- mat.CV.feat[x, ]
    y.feat <- mat.CV.feat[y, ]
    
    feat.pair <- rbind(x.feat, y.feat)
    feat.pair <- apply(feat.pair, 2, sort.col)
    
    x.feat <- feat.pair[1, ]
    y.feat <- feat.pair[2, ]
    
    f.xy <- vector(length=5)
    f.x  <- vector(length=5)
    f.y  <- vector(length=5)
    for (p in 1:5) {
      f.xy[p] <- feat.pair.freq.mat[x.feat[p], y.feat[p]]
      f.x[p]  <- feat.freq.vec[x.feat[p]]  # frequency of x in the segments
      f.y[p]  <- feat.freq.vec[y.feat[p]]
    }
    
    pmi     <- list()
    pmi$V1  <- x
    pmi$V2  <- y
    pmi$pmi <- PFPMI(f.xy, f.x, f.y, corpus.feat)
    return(pmi)
  }
  
  score.tmp <- foreach(i = 1:seg.pair.num, .combine = c) %dopar% {
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
  
  for (i in 1:seg.pair.num) {
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
