library(MASS)

source("lib/load_phoneme.R")
source("lib/pmi/pmi_tools.R")

library(tictoc)

PFPMI <- function(x, y, N1, N2, V1, V2, pair_freq_mat, seg_freq_vec) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  # Args:
  #   x, y: the feature vectors
  #   N1, N2: the denominators for the PMI
  #   V1, V2: the paramators for the Laplace smoothing
  #   pair_freq_mat: the frequency matrix of the feature pairs
  #   seg_freq_vec: the frequency vector of the features
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).

  feat.num <- length(x)

  f_xy <- vector(length = feat.num)
  f_x  <- vector(length = feat.num)
  f_y  <- vector(length = feat.num)
  for (p in 1:feat.num) {
    f_xy[p] <- pair_freq_mat[x[p], y[p]]
    f_x[p]  <- seg_freq_vec[x[p]]
    f_y[p]  <- seg_freq_vec[y[p]]
  }

  p_xy <- vector(length = feat.num)
  p_x  <- vector(length = feat.num)
  p_y  <- vector(length = feat.num)
  for (p in 1:feat.num) {
    p_xy[p] <- (f_xy[p] + 1) / (N1 + V1[p])  # probability of the co-occurrence frequency of xy
    p_x[p]  <- (f_x[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of x
    p_y[p]  <- (f_y[p] + 1) / (N2 + V2[p])  # probability of the occurrence frequency of y
  }

  pf_pmi <- t(p_xy) %*% ginv(p_x %*% t(p_y))

  return(pf_pmi)
}


smoothing <- function(corpus, feat.num) {
  # Initialization for the Laplace smoothing
  V1.all <- unique(paste(corpus[1, ], corpus[2, ]))  # number of segment pair types
  V2.all <- unique(as.vector(corpus))  # number of symbol types
  V1     <- NULL  # The number of feature pair types for each column.
  V2     <- NULL  # The number of feature types for each column.
  for (p in 1:feat.num) {
    V1[p] <- length(c(grep(paste(p, "C", sep = ""), V1.all),
                      grep(paste(p, "V", sep = ""), V1.all)))
    V2[p] <- length(c(grep(paste(p, "C", sep = ""), V2.all),
                      grep(paste(p, "V", sep = ""), V2.all)))
  }

  list(V1, V2)
}


calc_pf_pmi <- function(corpus_phone, mat.X.feat) {
  # Create the segment vector and the segment pairs matrix.
  phone_pair_mat <- make_pair_mat(corpus_phone)
  phone_pair_num <- dim(phone_pair_mat)[1]

  feat.num <- dim(mat.X.feat)[2]

  # Initialization for converting the corpus_phone to the feature corpus.
  gap <- matrix("-", 1, feat.num, dimnames = list("-"))
  feat_mat <- rbind(mat.X.feat, gap)

  # Convert from corpus_phone to feature corpus.
  N <- dim(corpus_phone)[2]
  print("corpus_feat")
  tic()

  corpus_feat <- mclapply(1:N, (function(j, x, y){
    mat <- rbind(x[y[1, j], ], x[y[2, j], ])
    mat <- apply(mat, 2, sort)
    return(mat)
  }), feat_mat, corpus_phone)

  corpus_feat1 <- mclapply(corpus_feat, (function(x){
    return(x[1, ])
  }))

  corpus_feat2 <- mclapply(corpus_feat, (function(x){
    return(x[2, ])
  }))

  corpus_feat <- rbind(unlist(corpus_feat1), unlist(corpus_feat2))
  toc()

  # Create the feature pairs matrix.
  pair_mat <- make_pair_mat(corpus_feat, identical = T)

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(pair_mat, corpus_feat)
  seg_freq_vec  <- MakeFreqVec(corpus_feat)

  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus_phone)[2]  # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures

  # Initialization for the Laplace smoothing
  V <- smoothing(corpus_feat, feat.num)
  V1 <- V[[1]]
  V2 <- V[[2]]

  # Calculate the PF-PMI for all segment pairs.
  print("Calculating pf_pmi_list")
  pf_pmi_list <- foreach(i = 1:phone_pair_num, .inorder = T) %dopar% {

    x <- phone_pair_mat[i, 1]
    y <- phone_pair_mat[i, 2]

    feat_pair_mat <- rbind(feat_mat[x, ], feat_mat[y, ])
    feat_pair_mat <- apply(feat_pair_mat, 2, sort)

    x_feat <- feat_pair_mat[1, ]
    y_feat <- feat_pair_mat[2, ]

    pf_pmi <- PFPMI(x_feat, y_feat, N1, N2, V1, V2,
                    pair_freq_mat = pair_freq_mat, seg_freq_vec = seg_freq_vec)

    pmi     <- list()
    pmi$V1  <- x
    pmi$V2  <- y
    pmi$pmi <- pf_pmi
    return(pmi)
  }

  pf_pmi_list
}


UpdatePFPMI <- function(psa_list, s, cv_sep=F) {
  # Compute the PMI of the PSA list.
  #
  # Args:
  #   psa_list: THe PSA list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The scoring matrix that was updated by the PMI-weighting.
  cat("\n")
  print("Updating PF-PMI")

  # Make the phones corpus.
  corpus_phone <- MakeCorpus(psa_list)

  if (cv_sep) {
    print("Enabled CV-separation.")
    corpus_cons  <- sep_corpus(C, corpus_phone)
    corpus_vowel <- sep_corpus(V, corpus_phone)

    pf_pmi_list_cons  <- calc_pf_pmi(corpus_cons, mat.C.feat)
    pf_pmi_list_vowel <- calc_pf_pmi(corpus_vowel, mat.V.feat)

    pf_pmi_list <- c(pf_pmi_list_cons, pf_pmi_list_vowel)
  } else {
    pf_pmi_list  <- calc_pf_pmi(corpus_phone, mat.CV.feat)
  }

  phone_pair_num <- length(pf_pmi_list)

  # Invert the PF-PMI for all segment pairs.
  score_tmp <- foreach(i = 1:phone_pair_num, .combine = c, .inorder = T) %dopar% {
    pf_pmi <- pf_pmi_list[[i]]$pmi
    #-sum(abs(pf_pmi))  # L1 norm
    -sqrt(sum(pf_pmi * pf_pmi))  # L2 norm
  }

  pmi <- list()
  if (cv_sep) {
    # NOP
  } else {
    pmi$pmi_mat <- AggrtPMI(s, pf_pmi_list)
  }
  pmi$s <- pmi2dist(s, score_tmp, pf_pmi_list)
  return(pmi)
}
