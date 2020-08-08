
check_feat_dup <- function(mat.X.feat) {
  # mat.X.feat: a matrix of distinctive features.

  X <- dimnames(mat.X.feat)[[1]]
  M <- dim(mat.X.feat)[1]
  pair <- t(combn(M, 2))
  N <- dim(pair)[1]
  for (i in 1:N) {
    seq1 <- paste(mat.X.feat[pair[i, 1], ], collapse = "")
    seq2 <- paste(mat.X.feat[pair[i, 2], ], collapse = "")
    if (seq1 == seq2) {
      print(paste(X[pair[i, 1]], X[pair[i, 2]]))
    }
  }
}
