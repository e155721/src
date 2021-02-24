PairwisePMI <- function(psa_list, list_words, s, method, cv_sep=F) {
  # Update the scoring matrix by calculating the PMI iteratively.
  #
  # Args:
  #   psa_list: The list of the PSAs of all input words.
  #   list_words: The list of all input words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix.
  s_old <- s
  N <- length(s_old)
  dim_s <- dim(s)[1]
  s_old[1:dim_s, 1:dim_s] <- 0
  # START OF LOOP
  loop <- 0
  while (1) {

    diff <- N - sum(s == s_old)
    if (diff == 0) {
      break
    } else {
      s_old <- s
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
    rm(psa_list)
    gc()
    gc()

    if (cv_sep) {
      print("Enabled CV-separation.")
      corpus_cons  <- sep_corpus("C", corpus_phone)
      corpus_vowel <- sep_corpus("V", corpus_phone)
      rm(corpus_phone)
      gc()
      gc()

      pmi_list_cons  <- method(corpus_cons)
      pmi_list_vowel <- method(corpus_vowel)

      attributes(pmi_list_cons)  <- list(sound = "C")
      attributes(pmi_list_vowel) <- list(sound = "V")

      s <- conv_pmi(pmi_list_cons, s)
      s <- conv_pmi(pmi_list_vowel, s)

      s[C, V] <- Inf
      s[V, C] <- Inf

      pmi_list <- c(pmi_list_cons, pmi_list_vowel)
      rm(pmi_list_cons)
      rm(pmi_list_vowel)
      gc()
      gc()
    } else {
      pmi_list  <- method(corpus_phone)
      rm(corpus_phone)
      gc()
      gc()
      s <- conv_pmi(pmi_list, s)
    }

    # Compute the new PSA using the new scoring matrix.
    psa_list <- PSAforEachWord(list_words, s, dist = T)
  }
  # END OF LOOP

  pmi <- list()
  pmi$psa_list <- psa_list
  pmi$pmi_list <- pmi_list
  pmi$s <- s
  return(pmi)
}
