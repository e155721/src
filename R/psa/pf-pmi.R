library(gtools)
library(MASS)

source("lib/load_phoneme.R")
source("psa/pmi_tools.R")

sym2feat <- function(x, args) {
  return(args[x, ])
}

smoothing <- function(corpus) {
  # Initialization for the Laplace smoothing
  V1.all <- unique(paste(corpus[1, ], corpus[2, ]))  # number of segment pair types
  V2.all <- unique(as.vector(corpus))  # number of symbol types
  V1     <- NULL  # The number of feature pair types for each column.
  V2     <- NULL  # The number of feature types for each column.
  for (p in 1:feat.num) {
    V1[p] <- length(c(grep(paste(p, "C", sep = ""), V1.all),
                      grep(paste(p, "V", sep = ""), V1.all)))
    V2[p] <- length(c(grep(paste(p, "C", sep = ""), V2.all),
                      grep(paste(p, "V", sep = ""), V2.all)))
  }

  list(V1, V2)
}

PFPMI <- function(x, y, N1, N2, V1, V2, pair_freq_mat, seg_freq_vec) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  # Args:
  #   x, y: the feature vectors
  #   N1, N2: the denominators for the PMI
  #   V1, V2: the paramators for the Laplace smoothing
  #   pair_freq_mat: the frequency matrix of the feature pairs
  #   seg_freq_vec: the frequency vector of the features
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).

  f.xy <- vector(length = feat.num)
  f.x  <- vector(length = feat.num)
  f.y  <- vector(length = feat.num)
  for (p in 1:feat.num) {
    f.xy[p] <- pair_freq_mat[x[p], y[p]]
    f.x[p]  <- seg_freq_vec[x[p]]
    f.y[p]  <- seg_freq_vec[y[p]]
  }

  p.xy <- vector(length = feat.num)
  p.x  <- vector(length = feat.num)
  p.y  <- vector(length = feat.num)
  for (p in 1:feat.num) {
    p.xy[p] <- (f.xy[p] + 1) / (N1 + V1[p])  # probability of the co-occurrence frequency of xy
    p.x[p]  <- (f.x[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of x
    p.y[p]  <- (f.y[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of y
  }

  pf_pmi <- t(p.xy) %*% ginv(p.x %*% t(p.y))

  return(pf_pmi)
}

UpdatePFPMI <- function(psa.list, s) {
  # Compute the PMI of the PSA list.
  #
  # Args:
  #   psa.list: THe PSA list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The scoring matrix that was updated by the PMI-weighting.
  cat("\n")
  print("Calculate PF-PMI")

  # Make the phones corpus.
  corpus_phone <- MakeCorpus(psa.list)

  # Create the segment vector and the segment pairs matrix.
  phone_vec <- unique(as.vector(corpus_phone))
  phone_pair_mat <- t(combn(x = phone_vec, m = 2))
  phone_pair_num <- dim(phone_pair_mat)[1]

  # Initialization for converting the corpus_phone to the feature corpus.
  gap <- as.vector(matrix("-", 1, feat.num))
  feat_mat <- rbind(mat.CV.feat, gap)
  dimnames(feat_mat) <- list(c(C, V, "-"), NULL)

  # Convert from corpus_phone to feature corpus.
  corpus <- t(apply(corpus_phone, 1, sym2feat, feat_mat))
  corpus <- apply(corpus, 2, sort)

  # Create the features vector and the feature pairs matrix.
  feat_vec <- unique(as.vector(corpus))
  pair_mat <- combn(x = feat_vec, m = 2)
  pair_mat <- cbind(pair_mat, rbind(feat_vec, feat_vec))  # add the identical feature pairs.
  pair_mat <- t(apply(pair_mat, 2, sort))

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(feat_vec, pair_mat, corpus)
  seg_freq_vec  <- MakeFreqVec(feat_vec, corpus)

  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus)[2] / feat.num # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures

  # Initialization for the Laplace smoothing
  V <- smoothing(corpus)
  V1 <- V[[1]]
  V2 <- V[[2]]

  # Calculate the PF-PMI for all segment pairs.
  pf_pmi_list <- foreach(i = 1:phone_pair_num) %dopar% {

    x <- phone_pair_mat[i, 1]
    y <- phone_pair_mat[i, 2]

    feat_pair_mat <- rbind(feat_mat[x, ], feat_mat[y, ])
    feat_pair_mat <- apply(feat_pair_mat, 2, sort)

    x_feat <- feat_pair_mat[1, ]
    y_feat <- feat_pair_mat[2, ]

    pf_pmi <- PFPMI(x_feat, y_feat, N1, N2, V1, V2,
                    pair_freq_mat = pair_freq_mat, seg_freq_vec = seg_freq_vec)

    pmi     <- list()
    pmi$V1  <- x
    pmi$V2  <- y
    pmi$pmi <- pf_pmi
    return(pmi)
  }

  # Invert the PF-PMI for all segment pairs.
  score.tmp <- foreach(i = 1:phone_pair_num, .combine = c) %dopar% {
    pf_pmi <- pf_pmi_list[[i]]$pmi
    #-sum(abs(pf_pmi))  # L1 norm
    -sqrt(sum(pf_pmi * pf_pmi))  # L2 norm
  }

  pmi <- list()
  pmi$pmi.mat <- AggrtPMI(s, pf_pmi_list)
  pmi$s       <- pmi2dist(score.tmp, pf_pmi_list)
  return(pmi)
}
