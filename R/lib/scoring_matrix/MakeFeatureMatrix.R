MakeFeatureMatrix <- function(s5=NA, p=NA) {
  # Make the scoring matrix using the phoneme features.
  #
  # Args:
  #   s5: The penalty for the pairs of consonant and vowel.
  #    p: The Gap penalty.
  #
  # Returns:
  #   The scoring matrix using the phoneme features.
  # Cnosonants
  C <- as.matrix(read.table("lib/data/symbols/consonants")[, 1])
  C <- t(C)
  num.C <- dim(C)[2]
  
  # Vowels
  V <- as.matrix(read.table("lib/data/symbols/vowels")[, 1])
  V <- t(V)
  num.V <- dim(V)[2]
  
  # Consonant features
  C.feat <- as.matrix(read.table("lib/data/features/consonants_values"))
  dimnames(C.feat) <- list(C, NULL)
  C.match <- matrix(NA, num.C, num.C, dimnames=list(C, C))
  for (i in C)
    for (j in C)
      C.match[i, j] <- sum(C.feat[i, ] == C.feat[j, ])
  
  # Vowel features
  V.feat <- as.matrix(read.table("lib/data/features/vowels_values"))
  dimnames(V.feat) <- list(V, NULL)
  V.match <- matrix(NA, num.V, num.V, dimnames=list(V, V))
  for (i in V)
    for(j in V)
      V.match[i, j] <- sum(V.feat[i, ] == V.feat[j, ])
  
  # Make the scoring matrix.
  symbols <- c(C, V, "-")
  score.row <- num.C + num.V + 1
  score.col <- num.C + num.V + 1
  
  s <- matrix(s5, nrow = score.row, ncol = score.col, 
              dimnames = list(symbols, symbols))
  
  s[C, C] <- C.match
  s[V, V] <- V.match
  s["-", ] <- p
  s[, "-"] <- p
  s["-", "-"] <- 0
  
  return(s)
}
