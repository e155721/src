library(tictoc)

MakeCorpus <- function(psa_list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa_list: A list of the PSA lists.
  #
  # Returns:
  #   A corpus to calculate PMI.
  print("MakeCorpus")
  tic()

  psa_list <- unlist(psa_list, recursive = F)
  M <- length(psa_list)
  seq1_list <- list()
  seq2_list <- list()
  for (i in 1:M) {
    seq1_list[[i]] <- psa_list[[i]]$seq1[1, -1, drop = F]
    seq2_list[[i]] <- psa_list[[i]]$seq2[1, -1, drop = F]
  }

  seq1 <- unlist(seq1_list)
  seq2 <- unlist(seq2_list)
  corpus <- rbind(seq1, seq2)

  # Removes identical segments from the corpus.
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop = F]
  }
  corpus <- apply(corpus, 2, sort)

  toc()
  return(corpus)
}


sep_corpus <- function(sound, corpus) {
  print("sep_corpus")
  tic()

  if (sound == "C") {
    X <- C
  } else {
    X <- V
  }

  x.idx <- NULL
  for (x in X) {
    x.idx <- c(x.idx, which(x == corpus[1, ]))
    x.idx <- c(x.idx, which(x == corpus[2, ]))
  }
  x.idx <- unique(x.idx)

  corpus <- corpus[, x.idx]
  corpus <- apply(corpus, 2, sort)
  attributes(corpus) <- list(sound = sound, dim = dim(corpus))

  toc()
  return(corpus)
}


make_pair_mat <- function(dat, identical=F){
  # dat: a matrix or vector
  print("make_pair_mat")
  tic()

  seg_vec <- unique(as.vector(dat))
  pair_mat <- combn(x = seg_vec, m = 2)
  pair_mat <- apply(X = pair_mat, MARGIN = 2, FUN = sort)
  if (identical) {
    # 'idx' will be 'logical(0)' if 'seg_vec' does not include a gap.
    # It will be FALSE when 'logical(0)' is compared to itself by '=='.
    # It shows that 'seg_vec' includes a gap if the 'if statement' below will be TRUE.
    idx <- which(seg_vec == "-")
    if (isTRUE(idx == idx)) {
      seg_vec <- seg_vec[-idx]
    }

    # Add the identical feature pairs.
    pair_mat <- cbind(pair_mat, rbind(seg_vec, seg_vec))
  }
  pair_mat <- t(pair_mat)

  toc()
  return(pair_mat)
}


MakeFreqMat <- function(seg.pair.mat, corpus) {
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

  seg_pair_tmp <- paste(seg.pair.mat[, 1], seg.pair.mat[, 2])
  corpus_tmp <- paste(corpus[1, ], corpus[2, ], sep = " ")
  tmp_list <- mclapply(1:seg.pair.num, (function(i, x, y){
    return(sum(x[i] == y))
  }), seg_pair_tmp, corpus_tmp)

  for (i in 1:seg.pair.num) {
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    seg.pair.freq.mat[x, y] <- tmp_list[[i]]
  }

  toc()
  return(seg.pair.freq.mat)
}


MakeFreqVec <- function(corpus) {
  # Create the vector of segmens frequency from a corpus.
  #
  # Args:
  #   seg.vec: a segment vector
  #   corpus: a corpus
  #
  # Return:
  #   the vector of segments frequency.
  print("MakeFreqVec")
  tic()

  seg.vec <- unique(as.vector(corpus))
  seg.num <- length(seg.vec)

  # Calculate the frequency vector for individual segments.
  seg.freq.vec <- vector(mode = "numeric", seg.num)
  names(seg.freq.vec) <- seg.vec
  for (i in 1:seg.num) {
    x <- seg.vec[i]
    seg.freq.vec[x] <- sum(x == corpus)
  }

  toc()
  return(seg.freq.vec)
}


AggrtPMI <- function(s, pmi.list, mat.X.feat) {
  # Create the PMI matrix.
  #
  # Args:
  #   s: a scoring matrix
  #   pmi.list: a list of the PMIs for each segment pair.
  #
  # Return:
  #   the matrix of the PMIs.
  print("AggrtPMI")
  tic()

  # The three-dimensional array to save the PF-PMI for each symbol pairs.
  s.dim <- dim(s)[1]
  s.names <- dimnames(s)[[1]]
  pmi_mat <- array(NA, dim = c(s.dim, s.dim, dim(mat.X.feat)[2]), dimnames = list(s.names, s.names))

  seg.pair.num <- length(pmi.list)
  for (i in 1:seg.pair.num) {
    pmi_mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2, ] <- pmi.list[[i]]$pmi
    pmi_mat[pmi.list[[i]]$V2, pmi.list[[i]]$V1, ] <- pmi.list[[i]]$pmi
  }

  # Prevent pairs of CV.
  pmi_mat[C, V, ] <- NA
  pmi_mat[V, C, ] <- NA

  # If the symbol pair PMI has been used,
  # the matrix of the PMIs is changed
  # from a three-dimensional array to a matrix.
  if (length(pmi.list[[1]]$pmi) == 1) {
    pmi_mat <- as.matrix(pmi_mat[, , 1])
  }

  toc()
  return(pmi_mat)
}


conv_pmi <- function(pmi_list) {

  seg_pair_num <- length(pmi_list)

  if (length(pmi_list[[1]]$pmi) == 1) {
    # Invert the PMI for all segment pairs.
    score_tmp <- foreach(i = 1:seg_pair_num, .combine = c, .inorder = T) %dopar% {
      pmi_list[[i]]$pmi
    }
  } else {
    # Invert the PF-PMI for all segment pairs.
    score_tmp <- foreach(i = 1:seg_pair_num, .combine = c, .inorder = T) %dopar% {
      pmi <- pmi_list[[i]]$pmi
      #sum(abs(pmi))  # L1 norm
      sqrt(sum(pmi * pmi))  # L2 norm
    }
  }

  sound <- attributes(pmi_list)$sound
  if (is.null(sound)) {
    score_tmp <- score_tmp
  } else {
    score_tmp <- scale(score_tmp)
  }
  score_tmp <- -score_tmp

  return(score_tmp)
}
