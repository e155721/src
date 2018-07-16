mat <- makeMatrix(seq1, seq2)
mat <- initializeMat(mat, p)

rowLen <- length(seq1)
colLen <- length(seq2)

for (i in 2:rowLen) {
  for (j in 2: colLen) {
    mat[i,j] <- D(mat,i,j,p)[[1]]
    j = j + 1
  }
  i = i + 1
}