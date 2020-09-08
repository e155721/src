source("lib/load_phoneme.R")

MakeEditDistance <- function(cv=Inf) {
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

  # Make the scoring matrix.
  symbols <- c(C, V, "-")
  score.row <- num.C + num.V + 1
  score.col <- num.C + num.V + 1

  s <- matrix(cv, nrow = score.row, ncol = score.col,
              dimnames = list(symbols, symbols))

  s[C, C] <- 1
  s[V, V] <- 1
  s["-", ] <- 1
  s[, "-"] <- 1
  diag(s) <- 0

  return(s)
}
