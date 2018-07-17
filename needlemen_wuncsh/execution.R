source("needlemen_wuncsh/NeedlemanWuncsh.R")

needlemanWuncsh <- function(seq1, seq2)
{
  # this code defines gap penalty
  p <- -2
  
  # initialize variable
  seq1 <- append(seq1, NA, after = 0)
  seq2 <- append(seq2, NA, after = 0)
  # scoringMatrix <- read.table("scoring_matrix_for_alphabets.txt")
  scoringMatrix <- read.table("scoring_matrix_for_phonetic_sign.txt")
  scoringMatrix <- as.matrix(scoringMatrix)
  s <- s$new(seq1, seq2, scoringMatrix)
  
  # calculate matrix for sequence alignment
  mat <- makeMatrix(seq1, seq2)
  mat <- initializeMat(mat, p)
  
  rowLen <- length(seq1)
  colLen <- length(seq2)
  
  for (i in 2:rowLen) {
    for (j in 2: colLen) {
      mat[i,j, 1] <- D(mat,i,j,p,s)[[1]]
      mat[i,j, 2] <- D(mat,i,j,p,s)[[2]]
      j = j + 1
    }
    i = i + 1
  }
  
  # trace back
  score <- gap <- c() 
  i <- rowLen
  j <- colLen
  n <- 1
  while (TRUE) {
    if (i == 1 && j == 1) break
    score[n] <- mat[i, j, 1]
    gap[n] <- mat[i, j, 2]
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
  score <- rev(score)
  gap <- rev(gap)
  
  # output alignment
  s1 <- seq1[2:length(seq1)]
  s2 <- seq2[2:length(seq2)]
  
  align1 <- align2 <- c()
  i <- j <- 1
  for (t in 1:length(gap)) {
    if(gap[t] == 0) {
      align1 <- append(align1, s1[i])
      align2 <- append(align2, s2[j])
      i <- i + 1
      j <- j + 1
    } else if(gap[t] == 1) {
      align1 <- append(align1, s1[i])
      align2<- append(align2, "_")
      i <- i + 1
    } else {
      align1 <- append(align1, "_")
      align2 <- append(align2, s2[j])
      j <- j + 1
    }
  }
  
  print(c("seq1: ", align1))
  print(c("seq2: ", align2))
  print(c("score: ", sum(score)))
}
