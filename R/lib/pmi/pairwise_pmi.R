PairwisePMI <- function(psa.list, list.words, s, method, cv_sep=F) {
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
    rlt.pmi <- method(psa.list, s, cv_sep)
    pmi.mat <- rlt.pmi$pmi.mat
    s <- rlt.pmi$s
    # Compute the new PSA using the new scoring matrix.
    psa.list <- PSAforEachWord(list.words, s, dist = T)
  }
  # END OF LOOP

  pmi <- list()
  pmi$psa.list <- psa.list
  pmi$pmi.mat <- pmi.mat
  pmi$s <- s
  return(pmi)
}
