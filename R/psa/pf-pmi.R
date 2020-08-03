library(gtools)
library(MASS)

source("lib/load_phoneme.R")
source("psa/pmi_tools.R")
source("psa/calc_pf_pmi.R")

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

  feat.num <- length(x)

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

  pf_pmi_list <- calc_pf_pmi(corpus_phone, mat.CV.feat)
  phone_pair_num <- length(pf_pmi_list)

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
