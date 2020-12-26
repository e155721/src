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


UpdatePMI <- function(corpus) {
  # Create the segment pairs matrix.
  pair_mat <- make_pair_mat(corpus)
  seg_pair_num <- dim(pair_mat)[1]

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(pair_mat, corpus)
  seg_freq_vec  <- MakeFreqVec(corpus)

  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  V1 <- dim(pair_mat)[1]  # number of segment pair types
  V2 <- length(pair_mat) # number of symbol types

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

attributes(UpdatePMI) <- list(method = "pmi")
