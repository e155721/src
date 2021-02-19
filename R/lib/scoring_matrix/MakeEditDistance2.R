source("lib/load_phoneme.R")


add_feat_weight <- function(sound, s, p) {

  if (sound == "C") {
    X <- C
    mat.X.feat <- mat.C.feat
  } else if (sound == "V") {
    X <- V
    mat.X.feat <- mat.V.feat
  } else {
    X <- CV
    mat.X.feat <- mat.CV.feat
  }
  X <- c(X, "-")

  pair_cons <- combn(X, 2)
  pair_num  <- dim(pair_cons)[2]
  for (i in 1:pair_num) {
    x <- pair_cons[1,  i]
    y <- pair_cons[2,  i]

    feat_num <- dim(mat.X.feat)[2]
    x_feat <- mat.X.feat[x, ]
    y_feat <- mat.X.feat[y, ]
    cost <- NULL
    for (j in 1:feat_num) {
      xf <- unlist(strsplit(x_feat[j], split = sound))[2]
      yf <- unlist(strsplit(y_feat[j], split = sound))[2]

      if (xf == yf) {
        cost[j] <- 0
      } else if ((xf == "0") || (yf == "0")) {
        cost[j] <- p
      } else {
        cost[j] <- 1
      }
    }

    s[x, y] <- sum(cost)
    s[y, x] <- sum(cost)
  }

  return(s)
}


MakeEditDistance2 <- function(cv=Inf, p=1) {
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

  s <- add_feat_weight("C", s, p)
  s <- add_feat_weight("V", s, p)

  diag(s) <- 0

  return(s)
}
