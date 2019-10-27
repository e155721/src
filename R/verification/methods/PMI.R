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

f <- function(x, y, corpus) {
  # Computes the frequency of the symbol pairs (x, y) in the corpus.
  #
  # Args:
  #   x, y: Symbols.
  #   corpus: Corpus.
  #
  # Returns:
  #   The frequency of the symbol pairs (x, y).
  X <- x == corpus[1, ]
  Y <- y == corpus[2, ]
  Z <- X + Y
  f.xy <- length(Z[Z == 2])
  
  return(f.xy)
}

g <- function(x, corpus)
{
  # Computes the frequency of the symbols x in the corpus.
  #
  # Args:
  #   x: Symobol.
  #   corpus: Corpus.
  #
  # Returns:
  #   The frequency of the symbol x.   
  f.x <- length(corpus[corpus == x])
  
  return(f.x)
}

PMI <- function(x, y, corpus, E) {
  # Computes the PMI of symbol pair (x, y) in the corpus.
  # Args:
  #   x, y: The symbols.
  #   corputs: The corpus.
  #
  # Returns:
  #   The PMI of the symbol pair (x, y).
  N <- length(corpus)
  p.xy <- (f(x, y, corpus) / N) + E
  p.x <- g(x, corpus) / N
  p.y <- g(y, corpus) / N
  pmi <- log2(p.xy / (p.x * p.y))
  
  return(pmi)
}
