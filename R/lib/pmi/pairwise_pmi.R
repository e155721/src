PairwisePMI <- function(psa_list, list.words, s, method, cv_sep=F) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
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
      corpus_cons  <- sep_corpus("C", corpus_phone)
      corpus_vowel <- sep_corpus("V", corpus_phone)

      pmi_list_cons  <- method(corpus_cons)
      pmi_list_vowel <- method(corpus_vowel)

      attributes(pmi_list_cons) <- list(sound = "C")
      attributes(pmi_list_vowel) <- list(sound = "V")

      score_tmp <- c(conv_pmi(pmi_list_cons),
                     conv_pmi(pmi_list_vowel))

      pmi_list <- c(pmi_list_cons, pmi_list_vowel)
    } else {
      pmi_list  <- method(corpus_phone)
      score_tmp <- conv_pmi(pmi_list)
    }

    pmi_max <- max(score_tmp)
    pmi_min <- min(score_tmp)

    # Convert the PMI to the weight of edit operations.
    seg_pair_num <- length(score_tmp)
    for (i in 1:seg_pair_num) {
      s[pmi_list[[i]]$V1, pmi_list[[i]]$V2] <- (score_tmp[[i]] - pmi_min) / (pmi_max - pmi_min)
      s[pmi_list[[i]]$V2, pmi_list[[i]]$V1] <- (score_tmp[[i]] - pmi_min) / (pmi_max - pmi_min)
    }

    s[C, V] <- Inf
    s[V, C] <- Inf

    # Compute the new PSA using the new scoring matrix.
    psa_list <- PSAforEachWord(list.words, s, dist = T)
  }
  # END OF LOOP

  pmi <- list()
  pmi$psa_list <- psa_list
  pmi$pmi_list <- pmi_list
  pmi$s <- s
  return(pmi)
}
