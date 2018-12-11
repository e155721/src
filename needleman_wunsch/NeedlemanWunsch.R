.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
attach(.myfunc.env)

NeedlemanWunsch <- function(seq1, seq2, p1 = -1, p2 = -1, s)
{
  # initialize variable
  na <- matrix(NA, nrow = dim(seq1)[1])
  seq1 <- cbind(na, seq1)
  na <- matrix(NA, nrow = dim(seq2)[1])
  seq2 <- cbind(na, seq2)
  D <- D$new(seq1, seq2, p1, p2, s)
  
  # calculate matrix for sequence alignment
  mat <- makeMatrix(seq1, seq2)
  mat <- InitializeMat(mat, p1, p2)
  
  rowLen <- dim(seq1)[2]
  colLen <- dim(seq2)[2]

  for (i in 2:rowLen) {
    for (j in 2:colLen) {
      d <- D$getScore(mat,i,j)
      mat[i, j, 1] <- d[1]
      mat[i, j, 2] <- d[2]
    }
  }
  
  # trace back
  score <- traceVec <- c() 
  i <- rowLen
  j <- colLen
  n <- 1
  score <- mat[i, j, 1]
  while (TRUE) {
    if (i == 1 && j == 1) break
    traceVec[n] <- mat[i, j, 2]
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
  traceVec <- rev(traceVec)
  
  # output alignment
  s1 <- seq1[, 2:dim(seq1)[2]]
  s2 <- seq2[, 2:dim(seq2)[2]]

  print(s1)
  return(0)
  
  align1 <- align2 <- c()
  i <- j <- 1
  for (t in 1:length(traceVec)) {
    if(traceVec[t] == 0) {
      align1 <- append(align1, s1[i])
      align2 <- append(align2, s2[j])
      i <- i + 1
      j <- j + 1
    } else if(traceVec[t] == 1) {
      align1 <- append(align1, s1[i])
      align2 <- append(align2, "-")
      i <- i + 1
    } else {
      align1 <- append(align1, "-")
      align2 <- append(align2, s2[j])
      j <- j + 1
    }
  }
  
  align <- list(NA, NA, NA)
  names(align) <- c("seq1", "seq2", "score")
  align[["seq1"]] <- align1
  align[["seq2"]] <- align2
  align[["score"]] <- score
  
  return(align)
}
