MakeCorpus <- function(psa.aln) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.aln: A list of an pairwise sequence aligment resutls.
  #
  # Returns:
  #   A corpus to calculate PMI.
  N <- length(psa.aln)
  seq1 <- NULL
  seq2 <- NULL
  
  for (i in 1:N) {
    seq1 <- cbind(seq1, psa.aln[[i]]$seq1[1, -1, drop=F])
    seq2 <- cbind(seq2, psa.aln[[i]]$seq2[1, -1, drop=F])
  }
  corpus <- rbind(seq1, seq2)
  
  return(corpus)
}