mat <- makeMatrix(seq1, seq2)
mat <- initializeMat(mat, p)

rowLen <- length(seq1)
colLen <- length(seq2)

for (i in 2:rowLen) {
  for (j in 2: colLen) {
    mat[i,j, 1] <- D(mat,i,j,p)[[1]]
    mat[i,j, 2] <- D(mat,i,j,p)[[2]]
    j = j + 1
  }
  i = i + 1
}

alignmentScore <- array()
i <- rowLen
j <- colLen
n <- 1
while (TRUE) {
  if (i == 1 && j == 1) break
  alignmentScore[n] <- mat[i, j, 1]
  n <- n + 1

    trace <- mat[i, j, 2]
  if (trace == 0) {
    i <- i - 1
    j <- j - 1
  } else if (trace == 1) {
    i <- i - 1
  } else if (trace == -1){
    j <- j - 1
  }
}
alignmentScore <- rev(alignmentScore)