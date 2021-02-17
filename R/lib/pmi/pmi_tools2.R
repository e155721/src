make_feat_idx_mat <- function(feat_pair_mat) {
  # Make the matrix of the feature indexes.
  # Args:
  #   feat_pair_mat: The matrix of the feature pairs.
  #
  # Returns:
  #   The matrix of the feature indexes.

  M <- dim(feat_pair_mat)[1]

  feat_idx_mat <- matrix(NA, M, 2)

  for (i in 1:M) {

    pf1 <- feat_pair_mat[i, 1]
    pf2 <- feat_pair_mat[i, 2]

    if (sum(grep("C", pf1)) == 1) {
      X1 <- "C"
    } else if (sum(grep("V", pf1)) == 1) {
      X1 <- "V"
    } else {
      X1 <- NULL
    }

    if (sum(grep("C", pf2)) == 1) {
      X2 <- "C"
    } else if (sum(grep("V", pf2)) == 1) {
      X2 <- "V"
    } else {
      X2 <- NULL
    }

    if (is.null(X1)) {
      seg1 <- 1
    } else {
      seg1 <- as.numeric(unlist(strsplit(feat_pair_mat[i, 1], X1))[1])
    }

    if (is.null(X2)) {
      seg2 <- 1
    } else {
      seg2 <- as.numeric(unlist(strsplit(feat_pair_mat[i, 2], X2))[1])
    }
    feat_idx_mat[i, 1] <- seg1
    feat_idx_mat[i, 2] <- seg2

  }

  return(feat_idx_mat)
}


MakeFreqMat2 <- function(feat_pair_mat, corpus) {
  # Create the matrix of segment pairs frequency from a corpus.
  #
  # Args:
  #   feat_pair_mat: a segment pairs matrix
  #   corpus: a corpus
  #
  # Return:
  #   the matrix of segment pairs frequency.
  print("MakeFreqMat")

  feat_vec      <- unique(as.vector(feat_pair_mat))
  feat_num      <- length(feat_vec)
  feat_pair_num <- dim(feat_pair_mat)[1]

  # Calculate the frequency matrix for aligned segments.
  seg_pair_freq_mat <- matrix(0, feat_num, feat_num,
                              dimnames = list(feat_vec, feat_vec))

  # Make the matrix of the feature indexes.
  feat_idx_mat <- make_feat_idx_mat(feat_pair_mat)

  tmp_list <- mclapply(1:feat_pair_num, (function(i, x, y, z){
    # Compute the number of all combinations of the features.
    # Args:
    #   x: feat_pair_mat
    #   y: feat_idx_mat
    #   z: corpus
    #
    # Returns:
    #   The list of the number of the feature pairs in the corpus.

    pf1 <- x[i, 1]  # The first feature of the feature pair.
    pf2 <- x[i, 2]  # The second feature of the feature pair.

    pf_num1 <- y[i, 1]  # Get the number of the first feature.
    pf_num2 <- y[i, 2]  # Get the number of the second feature.

    feat_vec_idx1 <- seq(1, dim(z)[1], 2)  # The indexes of all first feature vectors of all feature vector pairs.
    feat_vec_idx2 <- seq(2, dim(z)[1], 2)  # The indexes of all second feature vectors of all feature vector pairs.

    a <- z[feat_vec_idx1, pf_num1] == pf1
    b <- z[feat_vec_idx2, pf_num2] == pf2

    # The total number of the feature pair of the 'pf1' and the 'pf2' in the corpus.
    feat_pair_freq <- sum(a * b)

    return(feat_pair_freq)
  }), feat_pair_mat, feat_idx_mat, corpus)

  for (i in 1:feat_pair_num) {
    x <- feat_pair_mat[i, 1]
    y <- feat_pair_mat[i, 2]
    seg_pair_freq_mat[x, y] <- tmp_list[[i]]
  }

  t_seg_pair_freq_mat <- t(seg_pair_freq_mat)
  diag(t_seg_pair_freq_mat) <- 0
  seg_pair_freq_mat <- seg_pair_freq_mat + t_seg_pair_freq_mat

  return(seg_pair_freq_mat)
}
