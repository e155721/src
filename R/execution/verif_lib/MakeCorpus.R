MakeCorpus <- function(psa.aln)
{
  N <- length(psa.aln)
  i <- 3
  seq1 <- t(as.matrix(psa.aln[[1]][-1], drop = F))
  seq2 <- t(as.matrix(psa.aln[[2]][-1], drop = F))
  while (i <= N) {
    seq1 <- cbind(seq1, t(as.matrix(psa.aln[[i]][-1], drop = F)))
    seq2 <- cbind(seq2, t(as.matrix(psa.aln[[i+1]][-1], drop = F)))
    i <- i+2  
  }
  corpus <- rbind(seq1, seq2)
  return(corpus)
}
