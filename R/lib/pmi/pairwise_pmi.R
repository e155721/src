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
    rlt.pmi <- method(psa_list, s, cv_sep)
    pmi_mat <- rlt.pmi$pmi_mat
    s <- rlt.pmi$s
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