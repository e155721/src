MakeCorpus <- function(psa.list) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.list: A list of an pairwise sequence aligment resutls.
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
  
  # Removes identical segments from the corpus.
  corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  
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
  f.x <- x == corpus[1, ]          # frequency of x in the segment pairs
  f.y <- y == corpus[2, ]          # frequency of y in the segment pairs
  f.xy <- f.x * f.y
  f.xy <- length(f.xy[f.xy == 1])  # frequency of xy in the segment pairs
  
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
  f.x <- length(corpus[corpus == x])  # frequency of x in the segments
  
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
  N1 <- dim(corpus)[2]  # number of the aligned segments
  N2 <- N1 * 2          # number of segments in the aligned segments
  
  V1 <- length(unique(paste(corpus[1, ], corpus[2, ])))  # number of symbol pairs types in the segment pairs
  V2 <- length(unique(as.vector(corpus)))                # number of symbol types in the segments
  
  p.xy <- (f(x, y, corpus) + 1) / (N1 + V1)  # probability of the co-occurrence frequency of xy
  p.x <- (g(x, corpus) + 1) / (N2 + V2)      # probability of the occurrence frequency of x
  p.y <- (g(y, corpus) + 1) / (N2 + V2)      # probability of the occurrence frequency of y
  pmi <- log2(p.xy / (p.x * p.y))            # calculating the pmi
  
  return(pmi)
}
