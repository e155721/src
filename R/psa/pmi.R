library(gtools)

source("lib/load_phoneme.R")
source("psa/pmi_tools.R")

PMI <- function(x, y, N1, N2, V1, V2, pair.freq, seg.freq) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  #
  # Args:
  #   x, y: the segment pairs
  #   N1, N2: the parametors for the PMI
  #   V1, V2: the parametors for the Laplace smoothing
  #   pair.freq: the frequency matrix of the pair of segments
  #   seg.freq: the frequency vector of the segments
  #
  # Returns:
  #   the PMI velue of the segment pair (x, y)
 
  f.xy <- pair.freq[x, y]
  f.x  <- seg.freq[x]
  f.y  <- seg.freq[y]
  
  p.xy <- (f.xy + 1) / (N1 + V1)  # probability of the co-occurrence frequency of xy
  p.x  <- (f.x + 1) / (N2 + V2)  # probability of the occurrence frequency of x
  p.y  <- (f.y + 1) / (N2 + V2)  # probability of the occurrence frequency of y
  pmi  <- log2(p.xy / (p.x * p.y))  # calculating the pmi
  
  return(pmi)
}

UpdatePMI <- function(psa.list, s) {
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
  
  corpus <- MakeCorpus(psa.list)
  # Remove identical segments from the corpus.
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop = F]
  }
  corpus <- apply(corpus, 2, sort)
  
  # Create the segment vector and the segment pairs matrix.
  seg.vec      <- unique(as.vector(corpus))
  seg.pair.mat <- apply(combn(x = seg.vec, m = 2), 2, sort)
  seg.pair.mat <- t(seg.pair.mat)
  seg.pair.num <- dim(seg.pair.mat)[1]
  
  # Create the frequency matrix and the vector.
  seg.pair.freq.mat <- MakeFreqMat(seg.vec, seg.pair.mat, corpus)
  seg.freq.vec      <- MakeFreqVec(seg.vec, corpus)
  
  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  V1 <- length(unique(paste(corpus[1, ], corpus[2, ])))  # number of segment pair types
  V2 <- length(unique(as.vector(corpus))) # number of symbol types

  # Calculate the PMI for all segment pairs.
  pmi.list <- foreach(i = 1:seg.pair.num) %dopar% {
    
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    pmi <- PMI(x = x, y = y, N1 = N1, N2 = N2, V1 = V1, V2 = V2,
               pair.freq = seg.pair.freq.mat, seg.freq = seg.freq.vec)
    
    score.vec     <- list()
    score.vec$V1  <- x
    score.vec$V2  <- y
    score.vec$pmi <- pmi
    return(score.vec)
  }

  # Invert the PMI for all segment pairs.
  score.tmp <- foreach(i = 1:seg.pair.num, .combine = c) %dopar% {
    -pmi.list[[i]]$pmi
  }
  
  pmi <- list()
  pmi$pmi.mat <- AggrtPMI(s, pmi.list)
  pmi$s       <- pmi2dist(score.tmp, pmi.list)
  return(pmi)
}
