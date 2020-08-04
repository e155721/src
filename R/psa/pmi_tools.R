MakeCorpus <- function(psa.list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.list: A list of the PSA lists.
  #
  # Returns:
  #   A corpus to calculate PMI.
  M <- length(psa.list)
  seq1 <- NULL
  seq2 <- NULL
  corpus <- NULL

  for (i in 1:M) {
    N <- length(psa.list[[i]])
    corpus.tmp <- foreach (j = 1:N, .combine = cbind) %dopar% {
      seq1 <- cbind(seq1, psa.list[[i]][[j]]$seq1[1, -1, drop=F])
      seq2 <- cbind(seq2, psa.list[[i]][[j]]$seq2[1, -1, drop=F])
      rbind(seq1, seq2)
    }
    corpus <- cbind(corpus, corpus.tmp)
  }

  # Removes identical segments from the corpus.
  if (sum(which(corpus[1, ] == corpus[2, ]) != 0)) {
    corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop = F]
  }
  corpus <- apply(corpus, 2, sort)

  return(corpus)
}


sep_corpus <- function(X, corpus) {
  x.idx <- NULL
  for (x in X) {
    x.idx <- c(x.idx, which(x == corpus[1, ]))
    x.idx <- c(x.idx, which(x == corpus[2, ]))
  }
  x.idx <- unique(x.idx)

  corpus <- corpus[, x.idx]
  corpus <- apply(corpus, 2, sort)
  corpus
}


MakeFreqMat <- function(seg.vec, seg.pair.mat, corpus) {
  # Create the matrix of segment pairs frequency from a corpus.
  #
  # Args:
  #   seg.vec: a segment vector
  #   seg.pair.mat: a segment pairs matrix
  #   corpus: a corpus
  #
  # Return:
  #   the matrix of segment pairs frequency.

  seg.num      <- length(seg.vec)
  seg.pair.num <- dim(seg.pair.mat)[1]

  # Calculate the frequency matrix for aligned segments.
  seg.pair.freq.mat <- matrix(0, seg.num, seg.num,
                              dimnames = list(seg.vec, seg.vec))
  for (i in 1:seg.pair.num) {
    x <- seg.pair.mat[i, 1]
    y <- seg.pair.mat[i, 2]
    seg.pair.freq.mat[x, y] <- sum((x == corpus[1, ]) * (y == (corpus[2, ])))  # frequency of xy in the segmentpairs
  }

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


AggrtPMI <- function(s, pmi.list) {
  # Create the PMI matrix.
  #
  # Args:
  #   s: a scoring matrix
  #   pmi.list: a list of the PMIs for each segment pair.
  #
  # Return:
  #   the matrix of the PMIs.

  # The three-dimensional array to save the PF-PMI for each symbol pairs.
  s.dim <- dim(s)[1]
  s.names <- dimnames(s)[[1]]
  pmi.mat <- array(NA, dim = c(s.dim, s.dim, dim(mat.C.feat)[2]), dimnames = list(s.names, s.names))

  seg.pair.num <- length(pmi.list)
  for (i in 1:seg.pair.num) {
    pmi.mat[pmi.list[[i]]$V1, pmi.list[[i]]$V2, ] <- pmi.list[[i]]$pmi
    pmi.mat[pmi.list[[i]]$V2, pmi.list[[i]]$V1, ] <- pmi.list[[i]]$pmi
  }

  # Prevent pairs of CV.
  pmi.mat[C, V, ] <- NA
  pmi.mat[V, C, ] <- NA

  # If the symbol pair PMI has been used,
  # the matrix of the PMIs is changed
  # from a three-dimensional array to a matrix.
  if (length(pmi.list[[1]]$pmi) == 1) {
    pmi.mat <- as.matrix(pmi.mat[, , 1])
  }

  return(pmi.mat)
}

pmi2dist <- function(s, score.tmp, pmi.list) {
  # Create a scoring matrix based the PMI.
  #
  # Args:
  #   s: a scoring matrix.
  #   score.tmp: a list of inverted the PMIs for each segment pair.
  #   pmi.list: a list of the PMIs for each segment pair.
  #
  # Return:
  #   the scoring matrix based the PMIs.

  pmi.max <- max(score.tmp)
  pmi.min <- min(score.tmp)

  # Convert the PMI to the weight of edit operations.
  seg.pair.num <- length(pmi.list)
  for (i in 1:seg.pair.num) {
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
    s[pmi.list[[i]]$V2, pmi.list[[i]]$V1] <- (score.tmp[[i]] - pmi.min) / (pmi.max - pmi.min)
  }

  s[C, V] <- Inf
  s[V, C] <- Inf

  return(s)
}
