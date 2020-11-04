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

  f_xy <- diag(pair_freq_mat[x, y])
  f_x  <- seg_freq_vec[x]
  f_y  <- seg_freq_vec[y]

  p_xy <- (f_xy + 1) / (N1 + V1) # probability of the co-occurrence frequency of xy
  p_x  <- (f_x + 1) / (N2 + V2)  # probability of the occurrence frequency of x
  p_y  <- (f_y + 1) / (N2 + V2)  # probability of the occurrence frequency of y

  pf_pmi <- t(p_xy) %*% ginv(p_x %*% t(p_y))

  return(pf_pmi)
}


smoothing <- function(pair_mat, feat.num) {
  # Initialization for the Laplace smoothing
  V1.all <- unique(paste(pair_mat[, 1], pair_mat[1, 2]))  # number of segment pair types
  V2.all <- unique(as.vector(pair_mat))  # number of symbol types
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
  V <- smoothing(pair_mat, feat.num)
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
