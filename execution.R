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

alignment <- list(NA, NA)
i <- rowLen
j <- colLen
n <- 1
while (TRUE) {
  if (i == 1 && j == 1) break
  alignment[[1]][n] <- mat[i, j, 1]
  alignment[[2]][n] <- mat[i, j, 2]
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
score <- rev(alignment[[1]])
gap <- rev(alignment[[2]])

s1 <- seq1[2:length(seq1)]
s2 <- seq2[2:length(seq2)]

ss1 <- c()
ss2 <- c()
i = j = 1

for (t in 1:length(gap)) {
  if(gap[t] == 0) {
    ss1 <- append(ss1, s1[i])
    ss2 <- append(ss2, s2[j])
    i <- i + 1
    j <- j + 1
  } else if(gap[t] == 1) {
    ss1 <- append(ss1, s1[i])
    ss2<- append(ss2, "_")
    i <- i + 1
  } else {
    ss1 <- append(ss1, "_")
    ss2 <- append(ss2, s2[j])
    j <- j + 1
  }
}
