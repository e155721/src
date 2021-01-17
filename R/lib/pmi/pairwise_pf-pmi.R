min_max <- function(x, min, max) {

  y <- (x - min) / (max - min)

  return(y)
}


pf2phone <- function(s, pmi_mat, corpus_phone, mat.X.feat) {

  phone_vec <- unique(as.vector(corpus_phone))
  phone_pair <- combn(phone_vec, 2)
  nump <- dim(phone_pair)[2]
  for (i in 1:nump) {
    p <- phone_pair[, i]
    pf1 <- mat.X.feat[p[1], ]
    pf2 <- mat.X.feat[p[2], ]
    s[p[1], p[2]] <- norm(diag(pmi_mat[pf1, pf2]), type = "2")
  }

  return(s)
}

PairwisePFPMI <- function(psa_list, list.words, s, method, cv_sep=F) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   psa_list: The list of the PSAs for each word.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  s.old <- s
  N <- length(s.old)
  dim_s <- dim(s)[1]
  s.old[1:dim_s, 1:dim_s] <- 0
  # START OF LOOP
  loop <- 0
  while (1) {

    diff <- N - sum(s == s.old)
    if (diff == 0) {
      break
    } else {
      s.old <- s
    }

    if (loop == 10) {
      print(paste("PairwisePMI:", "MAX LOOP"))
      break
    } else {
      loop <- loop + 1
    }
    print(paste("PairwisePMI:", loop))

    # Compute the new scoring matrix that is updated by the PMI-weighting.
    cat("\n")
    print("Updating PMI")

    # Make the phones corpus.
    corpus_phone <- MakeCorpus(psa_list)

    if (cv_sep) {

      print("Enabled CV-separation.")
      corpus_c <- sep_corpus("C", corpus_phone)
      corpus_v <- sep_corpus("V", corpus_phone)
      rm(corpus_phone)
      gc()
      gc()

      # Get the PF-PMI results.
      pf_pmi_list_c <- UpdatePFPMI(corpus_c)
      pf_pmi_list_v <- UpdatePFPMI(corpus_v)

      # Reverse the PF-PMI values.
      pmi_mat_c <- -pf_pmi_list_c$mat
      pmi_mat_v <- -pf_pmi_list_v$mat

      attributes(pmi_mat_c) <- list(sound = "C", dim = dim(pmi_mat_c), dimnames = dimnames(pmi_mat_c))
      attributes(pmi_mat_v) <- list(sound = "V", dim = dim(pmi_mat_v), dimnames = dimnames(pmi_mat_v))

      # The PF-PMI values are converted to the distances.
      min_c <- min(pmi_mat_c[!is.na(pmi_mat_c)])
      max_c <- max(pmi_mat_c[!is.na(pmi_mat_c)])
      pmi_mat_d_c <- apply(pmi_mat_c, c(1,2), min_max, min_c, max_c)
      diag(pmi_mat_d_c) <- 0

      min_v <- min(pmi_mat_v[!is.na(pmi_mat_v)])
      max_v <- max(pmi_mat_v[!is.na(pmi_mat_v)])
      pmi_mat_d_v <- apply(pmi_mat_v, c(1,2), min_max, min_v, max_v)
      diag(pmi_mat_d_v) <- 0

      # The phoneme features distance are changed to the phonetic symbols distance.
      s <- pf2phone(s, pmi_mat_d_c, corpus_c, mat.C.feat)
      s <- pf2phone(s, pmi_mat_d_v, corpus_v, mat.V.feat)

      s[C, V] <- Inf
      s[V, C] <- Inf

      pmi <- list()
      pmi$psa_list <- psa_list
      pmi$pmi_list$pmi_mat_c   <- pmi_mat_c
      pmi$pmi_list$pmi_mat_v   <- pmi_mat_v
      pmi$pmi_list$pair_freq_mat_c <- pf_pmi_list_c$pair_freq_mat
      pmi$pmi_list$seg_freq_vec_c  <- pf_pmi_list_c$seg_freq_vec
      pmi$pmi_list$pair_freq_mat_v <- pf_pmi_list_v$pair_freq_mat
      pmi$pmi_list$seg_freq_vec_v  <- pf_pmi_list_v$seg_freq_vec
      pmi$pmi_list$pmi_mat_d_c <- pmi_mat_d_c
      pmi$pmi_list$pmi_mat_d_v <- pmi_mat_d_v
      pmi$s <- s

    } else {

      # Get the PF-PMI results.
      pf_pmi_list <- UpdatePFPMI(corpus_phone)

      # Reverse the PF-PMI values.
      pmi_mat <- -pf_pmi_list$mat

      # The PF-PMI values are converted to the distances.
      min_phone <- min(pmi_mat[!is.na(pmi_mat)])
      max_phone <- max(pmi_mat[!is.na(pmi_mat)])
      pmi_mat_d <- apply(pmi_mat, c(1,2), min_max, min_phone, max_phone)
      diag(pmi_mat) <- 0

      # The phoneme features distance are changed to the phonetic symbols distance.
      s <- pf2phone(s, pmi_mat_d, corpus_phone, mat.CV.feat)

      pmi <- list()
      pmi$psa_list <- psa_list
      pmi$pmi_list$pmi_mat <- pmi_mat
      pmi$pmi_list$pair_freq_mat <- pf_pmi_list$pair_freq_mat
      pmi$pmi_list$seg_freq_vec  <- pf_pmi_list$seg_freq_vec
      pmi$pmi_list$pmi_mat_d <- pmi_mat_d
      pmi$s <- s

    }

    # Compute the new PSA using the new scoring matrix.
    psa_list <- PSAforEachWord(list.words, s, dist = T)
  }
  # END OF LOOP

  return(pmi)
}
