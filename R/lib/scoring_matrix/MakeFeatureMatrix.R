source("lib/load_phoneme.R")

MakeFeatureMatrix <- function(s5=NA, p=NA) {
  # Make the scoring matrix using the phoneme features.
  #
  # Args:
  #   s5: The penalty for the pairs of consonant and vowel.
  #    p: The Gap penalty.
  #
  # Returns:
  #   The scoring matrix using the phoneme features.
  # Get the number of phonemes.
  num.C <- length(C)
  num.V <- length(V)
  
  # Calculate the number of matching features.
  C.match <- matrix(NA, num.C, num.C, dimnames=list(C, C))
  for (i in C)
    for (j in C)
      C.match[i, j] <- sum(mat.C.feat[i, ] == mat.C.feat[j, ])
  
  V.match <- matrix(NA, num.V, num.V, dimnames=list(V, V))
  for (i in V)
    for(j in V)
      V.match[i, j] <- sum(mat.V.feat[i, ] == mat.V.feat[j, ])
  
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
