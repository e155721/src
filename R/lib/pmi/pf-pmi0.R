library(MASS)
library(tictoc)

source("lib/load_phoneme.R")
source("lib/pmi/pmi_tools.R")


smoothing <- function(pair_mat, feat.num) {
  # Initialization for the Laplace smoothing
  V1.all <- unique(paste(pair_mat[, 1], pair_mat[1, 2]))  # number of segment pair types
  V2.all <- unique(as.vector(pair_mat))  # number of symbol types
  V1 <- NULL  # The number of feature pair types for each column.
  V2 <- NULL  # The number of feature types for each column.
  for (p in 1:feat.num) {
    V1[p] <- length(c(grep(paste(p, "C", sep = ""), V1.all),
                      grep(paste(p, "V", sep = ""), V1.all)))
    V2[p] <- length(c(grep(paste(p, "C", sep = ""), V2.all),
                      grep(paste(p, "V", sep = ""), V2.all)))
  }

  list(V1, V2)
}


UpdatePFPMI0 <- function(corpus_phone) {
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

  # Convert from corpus_phone to feature corpus.
  N <- dim(corpus_phone)[2]
  # Initiallization for a denominator for the PF-PMI.
  N1 <- dim(corpus_phone)[2]  # number of the aligned features
  N2 <- N1 * 2  # number of features in the aligned faetures

  tic("corpus_feat")
  # The 'corpus_phone' is converted to the 'corpu_feat'.
  corpus_feat <- mclapply(1:N, (function(j, x, y){
    mat <- rbind(x[y[1, j], ], x[y[2, j], ])
    mat <- apply(mat, 2, sort)
    return(mat)
  }), mat.X.feat, corpus_phone)

  corpus_feat1 <- mclapply(corpus_feat, (function(x){
    return(x[1, ])
  }))

  corpus_feat2 <- mclapply(corpus_feat, (function(x){
    return(x[2, ])
  }))

  corpus_feat <- rbind(unlist(corpus_feat1), unlist(corpus_feat2))
  toc()

  rm(corpus_phone)
  gc()
  gc()

  feat_vec <- unique(as.vector(corpus_feat))
  feat_list <- list()
  for (f in feat_vec) {
    i <- as.numeric(unlist(strsplit(f, split = sound))[1])
    feat_list[[i]] <- NA
  }

  for (f in feat_vec) {
    i <- as.numeric(unlist(strsplit(f, split = sound))[1])
    feat_list[[i]] <- c(feat_list[[i]], f)
  }

  for (i in 1:length(feat_list)) {
    feat_list[[i]] <- feat_list[[i]][-1]
  }

  pair_list <- lapply(feat_list, make_pair_mat, F)
  pair_mat <- NULL
  for (pair in pair_list) {
    pair_mat <- rbind(pair_mat, pair)
  }

  # Create the feature pairs matrix.
  seg_vec <- sort(unique(as.vector(pair_mat)))
  corpus_feat <- remove_identical(corpus_feat)

  # Create the frequency matrix and the vector.
  pair_freq_mat <- MakeFreqMat(pair_mat, corpus_feat)
  seg_freq_vec <- MakeFreqVec(seg_vec, corpus_feat)

  # Initialization for the Laplace smoothing.
  V_tmp <- smoothing(pair_mat, feat.num)
  V1 <- V_tmp[[1]]
  V2 <- V_tmp[[2]]

  # Calculate the PF-PMI for all segment pairs.
  print("Calculating pf_pmi_list")
  feat_vec <- sort(unique(as.vector(pair_mat)))
  len <- length(feat_vec)
  pf_pmi_mat <- matrix(NA, len, len, dimnames = list(feat_vec, feat_vec))
  pair_num <- dim(pair_mat)[1]
  for (i in 1:pair_num) {

    x <- pair_mat[i, 1]
    y <- pair_mat[i, 2]

    pfx <- as.numeric(unlist(strsplit(x, split = sound))[1])
    pfy <- as.numeric(unlist(strsplit(y, split = sound))[1])

    pf_pmi_mat[x, y] <- PMI(x, y, N1, N2, V1[pfx], V2[pfy],
                            pair_freq_mat = pair_freq_mat, seg_freq_vec = seg_freq_vec)

  }

  # The PF-PMI matrix is converted to the symmetry matrix.
  pf_pmi_mat[lower.tri(pf_pmi_mat)] <- t(pf_pmi_mat)[lower.tri(pf_pmi_mat)]

  pf_pmi_list <- list()
  pf_pmi_list$mat <- pf_pmi_mat
  pf_pmi_list$pair_freq_mat <- pair_freq_mat
  pf_pmi_list$seg_freq_vec <- seg_freq_vec
  return(pf_pmi_list)
}

attributes(UpdatePFPMI0) <- list(method = "pf-pmi0")
