library(gtools)

source("lib/load_phoneme.R")
source("psa/pmi_tools.R")
source("psa/calc_pmi.R")

PMI <- function(x, y, N1, N2, V1, V2, pair_freq_mat, seg_freq_vec) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  #
  # Args:
  #   x, y: the segment pairs
  #   N1, N2: the parametors for the PMI
  #   V1, V2: the parametors for the Laplace smoothing
  #   pair_freq_mat: the frequency matrix of the pair of segments
  #   seg_freq_vec: the frequency vector of the segments
  #
  # Returns:
  #   the PMI velue of the segment pair (x, y)

  f.xy <- pair_freq_mat[x, y]
  f.x  <- seg_freq_vec[x]
  f.y  <- seg_freq_vec[y]

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

  pmi_list <- calc_pmi(corpus)
  seg_pair_num <- length(pmi_list)

  # Invert the PMI for all segment pairs.
  score.tmp <- foreach(i = 1:seg_pair_num, .combine = c, .inorder = T) %dopar% {
    -pmi_list[[i]]$pmi
  }

  pmi <- list()
  pmi$pmi.mat <- AggrtPMI(s, pmi_list)
  pmi$s       <- pmi2dist(score.tmp, pmi_list)
  return(pmi)
}
