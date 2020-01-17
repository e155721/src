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
  
  f.xy <- sum((x == corpus[1, ]) * (y == (corpus[2, ])))  # frequency of xy in the segmentpairs
  f.x <- sum(x == corpus)                                 # frequency of x in the segments
  f.y <- sum(y == corpus)                                 # frequency of y in the segments
  
  p.xy <- (f.xy + 1) / (N1 + V1)   # probability of the co-occurrence frequency of xy
  p.x <- (f.x + 1) / (N2 + V2)     # probability of the occurrence frequency of x
  p.y <- (f.y + 1) / (N2 + V2)     # probability of the occurrence frequency of y
  pmi <- log2(p.xy / (p.x * p.y))  # calculating the pmi
  
  return(pmi)
}
