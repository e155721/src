sym2feat <- function(x, args) {
  return(args[x, ])
}

convert_corpus <- function(corpus_phone, feat_mat) {
  # Convert from corpus_phone to feature corpus.
  corpus_feat <- t(apply(corpus_phone, 1, sym2feat, feat_mat))
  corpus_feat <- apply(corpus_feat, 2, sort)
  corpus_feat
}

smoothing <- function(corpus) {
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
  phone_vec <- unique(as.vector(corpus_phone))
  phone_pair_mat <- t(combn(x = phone_vec, m = 2))
  phone_pair_num <- dim(phone_pair_mat)[1]

  # Initialization for converting the corpus_phone to the feature corpus.
  gap <- matrix("-", 1, feat.num, dimnames = list("-"))
  feat_mat <- rbind(mat.X.feat, gap)

  # Convert from corpus_phone to feature corpus.
  corpus_feat <- convert_corpus(corpus_phone, feat_mat)

  # Create the features vector and the feature pairs matrix.
  feat_vec <- unique(as.vector(corpus_feat))
  pair_mat <- combn(x = feat_vec, m = 2)
  pair_mat <- cbind(pair_mat, rbind(feat_vec, feat_vec))  # add the identical feature pairs.
  pair_mat <- t(apply(pair_mat, 2, sort))

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(feat_vec, pair_mat, corpus_feat)
  seg_freq_vec  <- MakeFreqVec(feat_vec, corpus_feat)

  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus_feat)[2] / feat.num # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures

  # Initialization for the Laplace smoothing
  V <- smoothing(corpus_feat)
  V1 <- V[[1]]
  V2 <- V[[2]]

  # Calculate the PF-PMI for all segment pairs.
  pf_pmi_list <- foreach(i = 1:phone_pair_num) %dopar% {

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