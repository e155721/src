calc_pmi <- function(corpus) {
  # Create the segment vector and the segment pairs matrix.
  seg_vec      <- unique(as.vector(corpus))
  pair_mat <- apply(combn(x = seg_vec, m = 2), 2, sort)
  pair_mat <- t(pair_mat)
  seg_pair_num <- dim(pair_mat)[1]

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(seg_vec, pair_mat, corpus)
  seg_freq_vec  <- MakeFreqVec(seg_vec, corpus)

  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2  # number of segments in the aligned segments
  V1 <- length(unique(paste(corpus[1, ], corpus[2, ])))  # number of segment pair types
  V2 <- length(unique(as.vector(corpus))) # number of symbol types

  # Calculate the PMI for all segment pairs.
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