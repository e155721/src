library(MASS)

source("lib/load_phoneme.R")
source("lib/pmi/pmi_tools.R")

library(tictoc)

PFPMI <- function(x, y, N1, N2, pair_freq_mat, seg_freq_vec) {
  # Computes the PF-PMI of the feature vector pair (x, y) in the corpus.
  # Args:
  #   x, y: the feature vectors.
  #   N1: the number of the feature pairs in the corpus.
  #   N2: the number of the features.
  #   pair_freq_mat: the frequency matrix of the feature pairs.
  #   seg_freq_vec: the frequency vector of the features.
  #
  # Returns:
  #   The list of the PF-PMI vector and the elements which were used for calculating the PF-PMI.

  f_xy <- pair_freq_mat[x, y]
  # It is taken the diagonal of matrix A is if the PF-PMI1 is selected.
  if (g_pf_pmi == "1") {
    f_xy <- diag(f_xy)
  }

  f_x <- seg_freq_vec[x]
  f_y <- seg_freq_vec[y]

  A <- (f_xy) / (N1)  # probability of the co-occurrence frequency of xy
  p_x <- (f_x) / (N2)  # probability of the occurrence frequency of x
  p_y <- (f_y) / (N2)  # probability of the occurrence frequency of y
  B <- p_x %*% t(p_y)
  AB <- t(A) %*% ginv(B)

  # It is taken the diagonal of the PF-PMI matrix if the PF-PMI3 is selected.
  if (g_pf_pmi == "3") {
    AB <- diag(AB)
  }

  pf_pmi     <- list()
  pf_pmi$pmi <- AB
  pf_pmi$A   <- A
  pf_pmi$p_x <- p_x
  pf_pmi$p_y <- p_y
  pf_pmi$B   <- B

  return(pf_pmi)
}


UpdatePFPMI <- function(corpus_phone) {
  # Create the segment vector and the segment pairs matrix.
  phone_pair_mat <- make_pair_mat(corpus_phone)
  phone_pair_num <- dim(phone_pair_mat)[1]

  sound <- attributes(corpus_phone)$sound
  if (is.null(sound)) {
    mat.X.feat <- mat.CV.feat
  } else if (sound == "C") {
    mat.X.feat <- mat.C.feat
  } else if (sound == "V") {
    mat.X.feat <- mat.V.feat
  }
  feat_num <- dim(mat.X.feat)[2]

  # Initialization for converting the corpus_phone to the feature corpus.
  feat_mat <- mat.X.feat

  # Convert from corpus_phone to feature corpus.
  N <- dim(corpus_phone)[2]
  print("corpus_feat")
  tic()

  corpus_feat <- mclapply(1:N, (function(j, x, y){
    # Make the corpus of the feature vector pairs.
    # Args:
    #   x: feat_mat
    #   y: corpus_phone
    #
    # Returns:
    #   The corpus of the feature vector pairs.
    mat <- rbind(x[y[1, j], ], x[y[2, j], ])
    mat <- apply(mat, 2, sort)
    return(mat)
  }), feat_mat, corpus_phone)

  corpus_feat1 <- mclapply(corpus_feat, (function(x){
    # Make the list of all first vectors in all feature vector pairs.
    # Args:
    #   x: corpus_feat
    #
    # Returns:
    #   The list of all first vectors in all feature vector pairs.
    return(x[1, ])
  }))

  corpus_feat2 <- mclapply(corpus_feat, (function(x){
    # Make the list of all second vectors in all feature vector pairs.
    # Args:
    #   x: corpus_feat
    #
    # Returns:
    #   The list of all second vectors in all feature vector pairs.
    return(x[2, ])
  }))

  a <- unlist(corpus_feat1)  # The vector of the corpus_feat1.
  b <- unlist(corpus_feat2)  # The vector of the corpus_feat2.

  mat_a <- matrix(NA, N, feat_num)
  mat_b <- matrix(NA, N, feat_num)

  len <- N * feat_num
  for (j in 1:feat_num) {
    mat_a[, j] <- a[seq(j, len, feat_num)]
    mat_b[, j] <- b[seq(j, len, feat_num)]
  }

  # Remake the feature corpus as a matrix.
  corpus_feat <- matrix(NA, (N * 2), feat_num)
  corpus_feat[seq(1, dim(corpus_feat)[1], 2), ] <- mat_a
  corpus_feat[seq(2, dim(corpus_feat)[1], 2), ] <- mat_b
  toc()

  # Create the feature pairs matrix.
  pair_mat <- make_pair_mat(corpus_feat, identical = T)
  seg_vec <- sort(unique(as.vector(pair_mat)))

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat2(pair_mat, corpus_feat)
  seg_freq_vec <- MakeFreqVec(seg_vec, corpus_feat)

  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus_phone)[2]  # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures

  # Calculate the PF-PMI for all segment pairs.
  print("Calculating pf_pmi_list")
  pf_pmi_list <- foreach(i = 1:phone_pair_num, .inorder = T) %dopar% {

    x <- phone_pair_mat[i, 1]
    y <- phone_pair_mat[i, 2]

    x_feat <- feat_mat[x, ]
    y_feat <- feat_mat[y, ]

    pf_pmi <- PFPMI(x_feat, y_feat, N1, N2,
                    pair_freq_mat = pair_freq_mat, seg_freq_vec = seg_freq_vec)

    pf_pmi$V1 <- x
    pf_pmi$V2 <- y

    return(pf_pmi)
  }

  pf_pmi_list
}

attributes(UpdatePFPMI) <- list(method = "pf-pmi")
