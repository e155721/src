source("lib/load_phoneme.R")
source("lib/pmi/pmi_tools.R")

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

  f_xy <- pair_freq_mat[x, y]
  f_x  <- seg_freq_vec[x]
  f_y  <- seg_freq_vec[y]

  p_xy <- (f_xy + 1) / (N1 + V1)  # probability of the co-occurrence frequency of xy
  p_x  <- (f_x + 1) / (N2 + V2)  # probability of the occurrence frequency of x
  p_y  <- (f_y + 1) / (N2 + V2)  # probability of the occurrence frequency of y
  pmi  <- log2(p_xy / (p_x * p_y))  # calculating the pmi

  return(pmi)
}


calc_pmi <- function(corpus) {
  # Create the segment pairs matrix.
  pair_mat <- make_pair_mat(corpus)
  seg_pair_num <- dim(pair_mat)[1]

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(pair_mat, corpus)
  seg_freq_vec  <- MakeFreqVec(corpus)

  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  V1 <- length(unique(paste(corpus[1, ], corpus[2, ])))  # number of segment pair types
  V2 <- length(unique(as.vector(corpus))) # number of symbol types

  # Calculate the PMI for all segment pairs.
  print("Calculating pmi_list")
  pmi_list <- foreach(i = 1:seg_pair_num, .inorder = T) %dopar% {

    x <- pair_mat[i, 1]
    y <- pair_mat[i, 2]
    pmi <- PMI(x = x, y = y, N1 = N1, N2 = N2, V1 = V1, V2 = V2,
               pair_freq_mat = pair_freq_mat, seg_freq_vec = seg_freq_vec)

    score.vec     <- list()
    score.vec$V1  <- x
    score.vec$V2  <- y
    score.vec$pmi <- pmi
    return(score.vec)
  }

  pmi_list
}


UpdatePMI <- function(psa_list, s, cv_sep=F) {
  # Compute the PMI of the PSA list.
  #
  # Args:
  #   psa_list: THe PSA list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The scoring matrix that was updated by the PMI-weighting.
  cat("\n")
  print("Updating PMI")

  corpus <- MakeCorpus(psa_list)

  if (cv_sep) {
    print("Enabled CV-separation.")
    corpus_cons  <- sep_corpus(C, corpus)
    corpus_vowel <- sep_corpus(V, corpus)

    pmi_list_cons  <- calc_pmi(corpus_cons)
    pmi_list_vowel <- calc_pmi(corpus_vowel)

    pmi_list <- c(pmi_list_cons, pmi_list_vowel)
  } else {
    pmi_list  <- calc_pmi(corpus)
  }

  seg_pair_num <- length(pmi_list)

  # Invert the PMI for all segment pairs.
  score_tmp <- foreach(i = 1:seg_pair_num, .combine = c, .inorder = T) %dopar% {
    -pmi_list[[i]]$pmi
  }

  pmi <- list()
  pmi$pmi_mat <- AggrtPMI(s, pmi_list)
  pmi$s       <- pmi2dist(s, score_tmp, pmi_list)
  return(pmi)
}