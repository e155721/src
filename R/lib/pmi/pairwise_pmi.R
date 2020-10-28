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
  for (i in 1:N) {
    s.old[i] <- 0
  }
  # START OF LOOP
  loop <- 0
  while (1) {

    change_cores()
    diff <- N - sum(s == s.old)
    if (diff == 0) {
      break
    } else {
      s.old <- s
    }

    if (loop == 10) {
      print("MAX LOOP!!")
      break
    } else {
      loop <- loop + 1
    }

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

      pmi_list <- c(pmi_list_cons, pmi_list_vowel)
    } else {
      pmi_list  <- method(corpus_phone)
    }

    phone_pair_num <- length(pmi_list)

    if (cv_sep) {
      pmi_mat   <- list()
      pmi_mat$c <- AggrtPMI(s, pmi_list_cons, mat.C.feat)
      pmi_mat$v <- AggrtPMI(s, pmi_list_vowel, mat.V.feat)
    } else {
      pmi_mat <- AggrtPMI(s, pmi_list, mat.CV.feat)
    }
    s <- pmi2dist(s, pmi_list)

    # Compute the new PSA using the new scoring matrix.
    psa_list <- PSAforEachWord(list.words, s, dist = T)
  }
  # END OF LOOP

  pmi <- list()
  pmi$psa_list <- psa_list
  pmi$pmi_mat <- pmi_mat
  pmi$s <- s
  return(pmi)
}
