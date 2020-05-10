sort.col <- function(x) {
  return(sort(x))
}

MakeCorpus <- function(psa.list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.list: A list of the PSA lists.
  #
  # Returns:
  #   A corpus to calculate PMI.
  M <- length(psa.list)
  seq1 <- NULL
  seq2 <- NULL
  corpus <- NULL
  
  for (i in 1:M) {
    N <- length(psa.list[[i]])
    corpus.tmp <- foreach (j = 1:N, .combine = cbind) %dopar% {
      seq1 <- cbind(seq1, psa.list[[i]][[j]]$seq1[1, -1, drop=F])
      seq2 <- cbind(seq2, psa.list[[i]][[j]]$seq2[1, -1, drop=F])
      rbind(seq1, seq2)
    }
    corpus <- cbind(corpus, corpus.tmp)
  }
  
  return(corpus)
}
