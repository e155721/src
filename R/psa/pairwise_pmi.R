library(gtools)

source("lib/load_phoneme.R")

sort.col <- function(x) {
  return(sort(x))
}

MakeCorpus <- function(psa.list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.list: A list of an pairwise sequence aligment resutls.
  #
  # Returns:
  #   A corpus to calculate PMI.
  M <- length(psa.list)
  seq1 <- NULL
  seq2 <- NULL
  corpus <- NULL
  
  for (i in 1:M) {
    N <- length(psa.list[[i]])
    corpus.tmp <- foreach (j = 1:N, .combine = cbind) %dopar% {
      seq1 <- cbind(seq1, psa.list[[i]][[j]]$seq1[1, -1, drop=F])
      seq2 <- cbind(seq2, psa.list[[i]][[j]]$seq2[1, -1, drop=F])
      rbind(seq1, seq2)
    }
    corpus <- cbind(corpus, corpus.tmp)
  }
  
  return(corpus)
}

PMI <- function(x, y, corpus) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  # Args:
  #   x, y: The symbols.
  #   corputs: The corpus.
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).
  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  
  V1 <- length(unique(paste(corpus[1, ], corpus[2, ])))  # number of symbol pairs types in the segment pairs
  V2 <- length(unique(as.vector(corpus))) # number of symbol types in the segments
  
  f.xy <- sum((x == corpus[1, ]) * (y == (corpus[2, ])))  # frequency of xy in the segmentpairs
  f.x  <- sum(x == corpus)  # frequency of x in the segments
  f.y  <- sum(y == corpus)  # frequency of y in the segments
  
  p.xy <- (f.xy + 1) / (N1 + V1)  # probability of the co-occurrence frequency of xy
  p.x  <- (f.x + 1) / (N2 + V2)  # probability of the occurrence frequency of x
  p.y  <- (f.y + 1) / (N2 + V2)  # probability of the occurrence frequency of y
  pmi  <- log2(p.xy / (p.x * p.y))  # calculating the pmi
  
  return(pmi)
}

CalcPMI <- function(psa.list, s) {
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
  corpus <- apply(corpus, 2, sort.col)
  
  sym.vec <- unique(as.vector(corpus))
  sym.vec <- t(combn(x=sym.vec, m=2))
  len <- dim(sym.vec)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.vec$V1  <- sym.vec[i, 1]
    score.vec$V2  <- sym.vec[i, 2]
    score.vec$pmi <- PMI(sym.vec[i, 1], sym.vec[i, 2], corpus)
    return(score.vec)
  }
  
  score.tmp <- foreach(i = 1:len, .combine = c) %dopar% {
    -pmi.list[[i]]$pmi
  }
  pmi.max <- max(score.tmp)
  pmi.min <- min(score.tmp)
  
  s.dim <- dim(s)[1]
  s.names <- dimnames(s)[[1]]
  pmi.mat <- array(NA, dim = c(s.dim, s.dim), dimnames = list(s.names, s.names))
  
  for (i in 1:len) {
    # Save the PMI.
    pmi.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- pmi.list[[i]]$pmi
    pmi.mat[pmi.list[[i]]$V2, pmi.list[[i]]$V1] <- pmi.list[[i]]$pmi
    # Convert the PMI to the weight of edit operations.
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
    s[pmi.list[[i]]$V2, pmi.list[[i]]$V1] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
  }
  
  # Prevent pairs of CV.
  pmi.mat[C, V] <- NA
  pmi.mat[V, C] <- NA
  
  s[C, V] <- Inf
  s[V, C] <- Inf
  
  pmi <- list()
  pmi$pmi.mat <- pmi.mat
  pmi$s <- s
  
  return(pmi)
}

PairwisePMI <- function(psa.list, list.words, s) {
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
    rlt.pmi <- CalcPMI(psa.list, s)
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
