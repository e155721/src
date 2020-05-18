library(gtools)
library(MASS)

source("lib/load_phoneme.R")
source("psa/pmi_tools.R")

sym2feat <- function(x, args) {
  return(args[x, ])
}

PFPMI <- function(x, y, N1, N2, V1, V2, pair.freq, seg.freq) {
  # Computes the PMI of symbol pair (x, y) in the corpus.feat.
  # Args:
  #   x, y: the feature vectors
  #   N1, N2: the denominators for the PMI
  #   V1, V2: the paramators for the Laplace smoothing
  #   pair.freq: the frequency matrix of the feature pairs
  #   seg.freq: the frequency vector of the features
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).
  
  f.xy <- vector(length = 5)
  f.x  <- vector(length = 5)
  f.y  <- vector(length = 5)
  for (p in 1:5) {
    f.xy[p] <- pair.freq[x[p], y[p]]
    f.x[p]  <- seg.freq[x[p]]
    f.y[p]  <- seg.freq[y[p]]
  }
  
  p.xy <- vector(length = 5)
  p.x  <- vector(length = 5)
  p.y  <- vector(length = 5)
  for (p in 1:5) {
    p.xy[p] <- (f.xy[p] + 1) / (N1 + V1[p])  # probability of the co-occurrence frequency of xy
    p.x[p]  <- (f.x[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of x
    p.y[p]  <- (f.y[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of y
  }
  
  pmi <- t(p.xy) %*% ginv(p.x %*% t(p.y))
  
  return(pmi)
}

UpdatePFPMI <- function(psa.list, s, p) {
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
  # Removes identical segments from the corpus.
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop = F]
  }
  
  # Create the segment vector and the segment pairs matrix.
  seg.vec <- unique(as.vector(corpus))
  seg.pair.mat <- t(combn(x = seg.vec, m = 2))
  seg.pair.num <- dim(seg.pair.mat)[1]
  
  # Initialization for converting the corpus to the feature corpus.
  gap <- as.vector(matrix("-", 1, 5))
  feat.mat <- rbind(mat.CV.feat, gap)
  dimnames(feat.mat) <- list(c(C, V, "-"), NULL)
  
  # Convert from corpus to feature corpus.
  corpus.feat <- t(apply(corpus, 1, sym2feat, feat.mat))
  corpus.feat <- apply(corpus.feat, 2, sort)
  
  # Create the features vector and the feature pairs matrix.
  feat.vec      <- unique(as.vector(corpus.feat))
  feat.pair.mat <- combn(x = feat.vec, m = 2)
  feat.pair.mat <- cbind(feat.pair.mat, rbind(feat.vec, feat.vec))  # add the identical feature pairs.
  feat.pair.mat <- t(apply(feat.pair.mat, 2, sort))
  feat.pair.num <- dim(feat.pair.mat)[1]
  
  # Create the frequency matrix and the vector.
  feat.pair.freq.mat <- MakeFreqMat(feat.vec, feat.pair.mat, corpus.feat)
  feat.freq.vec      <- MakeFreqVec(feat.vec, corpus.feat)
  
  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus.feat)[2] / 5 # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures
  
  # Initialization for the Laplace smoothing
  V1.all <- unique(paste(corpus.feat[1, ], corpus.feat[2, ]))  # number of segment pair types
  V2.all <- unique(as.vector(corpus.feat))  # number of symbol types
  V1     <- NULL  # The number of feature pair types for each column.
  V2     <- NULL  # The number of feature types for each column.
  for (p in 1:5) {
    V1[p] <- length(c(grep(paste(p, "C", sep = ""), V1.all),
                      grep(paste(p, "V", sep = ""), V1.all)))
    V2[p] <- length(c(grep(paste(p, "C", sep = ""), V2.all),
                      grep(paste(p, "V", sep = ""), V2.all)))
  }
  
  # Calculate the PF-PMI for all segment pairs.
  pmi.list <- foreach(i = 1:seg.pair.num) %dopar% {
    
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    
    feat.pair <- rbind(feat.mat[x, ], feat.mat[y, ])
    feat.pair <- apply(feat.pair, 2, sort)
    
    x.feat <- feat.pair[1, ]
    y.feat <- feat.pair[2, ]
    
    pf.pmi <- PFPMI(x.feat, y.feat, N1, N2, V1, V2, 
                    pair.freq = feat.pair.freq.mat, seg.freq = feat.freq.vec)
    
    pmi     <- list()
    pmi$V1  <- x
    pmi$V2  <- y
    pmi$pmi <- pf.pmi
    return(pmi)
  }
  
  # Invert the PF-PMI for all segment pairs.
  score.tmp <- foreach(i = 1:seg.pair.num, .combine = c) %dopar% {
    pmi <- pmi.list[[i]]$pmi
    #-sum(abs(pmi))  # L1 norm
    -sqrt(sum(pmi * pmi))  # L2 norm
  }
  
  pmi <- list()
  pmi$pmi.mat <- AggrtPMI(s, pmi.list)
  pmi$s       <- pmi2dist(score.tmp, pmi.list)
  return(pmi)
}
