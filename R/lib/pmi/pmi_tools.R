


remove_identical <- function(corpus) {
  # Removes identical segments from the corpus.
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop = F]
  }
  return(corpus)
}


MakeCorpus <- function(psa_list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa_list: A list of the PSA lists.
  #
  # Returns:
  #   A corpus to calculate PMI.
  print("MakeCorpus")
  

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

  M <- length(seq1)
  corpus <- matrix(NA, 2, M)
  corpus[1, ] <- seq1
  corpus[2, ] <- seq2

  corpus <- remove_identical(corpus)
  corpus <- apply(corpus, 2, sort)

  
  return(corpus)
}


sep_corpus <- function(sound, corpus) {
  print("sep_corpus")
  

  if (sound == "C") {
    X <- C
  } else {
    X <- V
  }

  x.idx <- NULL
  for (x in X) {
    tmp1 <- which(x == corpus[1, ])
    M1 <- length(x.idx)
    N1 <- length(tmp1)
    if (sum(tmp1 == tmp1) != 0) {
      x.idx[(M1 + 1):(M1 + N1)] <- tmp1
    }

    tmp2 <- which(x == corpus[2, ])
    M2 <- length(x.idx)
    N2 <- length(tmp2)
    if (sum(tmp2 == tmp2) != 0) {
      x.idx[(M2 + 1):(M2 + N2)] <- tmp2
    }
  }
  x.idx <- unique(x.idx)

  corpus <- corpus[, x.idx]
  corpus <- apply(corpus, 2, sort)
  attributes(corpus) <- list(sound = sound, dim = dim(corpus))

  
  return(corpus)
}


make_pair_mat <- function(dat, identical=F){
  # dat: a matrix or vector
  print("make_pair_mat")
  

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
  

  seg.vec      <- sort(unique(as.vector(seg.pair.mat)))
  seg.num      <- length(seg.vec)
  seg.pair.num <- dim(seg.pair.mat)[1]

  # Calculate the frequency matrix for aligned segments.
  seg.pair.freq.mat <- matrix(NA, seg.num, seg.num,
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

  seg.pair.freq.mat[lower.tri(seg.pair.freq.mat)] <- t(seg.pair.freq.mat)[lower.tri(seg.pair.freq.mat)]

  return(seg.pair.freq.mat)
}


MakeFreqVec <- function(seg.vec, corpus) {
  # Create the vector of segmens frequency from a corpus.
  #
  # Args:
  #   seg.vec: a segment vector
  #   corpus: a corpus
  #
  # Return:
  #   the vector of segments frequency.
  print("MakeFreqVec")
  

  seg.num <- length(seg.vec)

  # Calculate the frequency vector for individual segments.
  seg.freq.vec <- vector(mode = "numeric", seg.num)
  names(seg.freq.vec) <- seg.vec
  for (i in 1:seg.num) {
    x <- seg.vec[i]
    seg.freq.vec[x] <- sum(x == corpus)
  }

  
  return(seg.freq.vec)
}


conv_pmi <- function(pmi_list, s) {

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
      #norm(pmi, "1")  # L1 norm
      norm(pmi, "2")  # L2 norm
    }
  }

  sound <- attributes(pmi_list)$sound
  if (is.null(sound)) {
    score_tmp <- score_tmp
  } else {
    score_tmp <- scale(score_tmp)
  }
  score_tmp <- -score_tmp

  pmi_max <- max(score_tmp)
  pmi_min <- min(score_tmp)

  # Convert the PMI to the weight of edit operations.
  seg_pair_num <- length(score_tmp)
  for (i in 1:seg_pair_num) {
    s[pmi_list[[i]]$V1, pmi_list[[i]]$V2] <- (score_tmp[[i]] - pmi_min) / (pmi_max - pmi_min)
    s[pmi_list[[i]]$V2, pmi_list[[i]]$V1] <- (score_tmp[[i]] - pmi_min) / (pmi_max - pmi_min)
  }

  return(s)
}


smoothing <- function(pair_mat, mat.X.feat) {
  # Compute the smoothing parameters.
  #
  # Args:
  #   pair_mat: the matrix of all feature pairs.
  #
  # Returns:
  #   The list of the smoothing parameters.


  sound <- attributes(mat.X.feat)$sound

  pf1 <- unlist(strsplit(pair_mat[, 1], split = sound))
  pf1 <- pf1[seq(1, length(pf1), 2)]
  pf2 <- unlist(strsplit(pair_mat[, 2], split = sound))
  pf2 <- pf2[seq(1, length(pf2), 2)]

  feat_vec <- unique(as.vector(pair_mat))  # the features vector

  feat_num <- dim(mat.X.feat)[2]
  V1 <- NULL  # the vector that each element is the number of the feature pair types.
  V2 <- NULL  # the vector that each element is the number of the feature types.

  for (p in 1:feat_num) {
    idx1 <- pf1 == p
    idx2 <- pf2 == p

    V1[p] <- sum(idx1 * idx2)
    V2[p] <- length(grep(paste(p, sound, sep = ""), feat_vec))

  }

  list(V1, V2)
}
