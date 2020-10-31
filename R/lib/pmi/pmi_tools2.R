make_idx_mat <- function(pair_mat) {

  M <- dim(pair_mat)[1]
  N <- dim(pair_mat)[2]

  pair_mat_idx <- matrix(NA, M, N)

  for (i in 1:M) {

    pf1 <- pair_mat[i, 1]
    pf2 <- pair_mat[i, 2]

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
      seg1 <- as.numeric(unlist(strsplit(pair_mat[i, 1], X1))[1])
    }

    if (is.null(X2)) {
      seg2 <- 1
    } else {
      seg2 <- as.numeric(unlist(strsplit(pair_mat[i, 2], X2))[1])
    }
    pair_mat_idx[i, 1] <- seg1
    pair_mat_idx[i, 2] <- seg2

  }

  return(pair_mat_idx)
}


MakeFreqMat2 <- function(seg.pair.mat, corpus) {
  # Create the matrix of segment pairs frequency from a corpus.
  #
  # Args:
  #   seg.vec: a segment vector
  #   seg.pair.mat: a segment pairs matrix
  #   corpus: a corpus
  #
  # Return:
  #   the matrix of segment pairs frequency.
  print("MakeFreqMat")
  tic()

  seg.vec      <- unique(as.vector(seg.pair.mat))
  seg.num      <- length(seg.vec)
  seg.pair.num <- dim(seg.pair.mat)[1]

  # Calculate the frequency matrix for aligned segments.
  seg.pair.freq.mat <- matrix(0, seg.num, seg.num,
                              dimnames = list(seg.vec, seg.vec))


  pair_mat_idx <- make_idx_mat(seg.pair.mat)

  tmp_list <- mclapply(1:seg.pair.num, (function(i, x, y, z){

    pf1 <- x[i, 1]
    pf2 <- x[i, 2]

    pf_idx1 <- y[i, 1]
    pf_idx2 <- y[i, 2]

    a <- z[seq(1, dim(z)[1], 2), pf_idx1] == pf1
    b <- z[seq(2, dim(z)[1], 2), pf_idx2] == pf2

    return(sum(a * b))
  }), seg.pair.mat, pair_mat_idx, corpus)

  for (i in 1:seg.pair.num) {
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    seg.pair.freq.mat[x, y] <- tmp_list[[i]]
  }

  toc()
  return(seg.pair.freq.mat)
}
