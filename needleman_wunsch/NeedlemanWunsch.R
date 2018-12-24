.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
attach(.myfunc.env)

NeedlemanWunsch <- function(seq1, seq2, p1 = -1, p2 = -1, s)
{
  # initialize variable
  g1 <- matrix("-", nrow = dim(seq1)[1])
  g2 <- matrix("-", nrow = dim(seq2)[1])
  
  # seq1 <- cbind(na1, seq1)
  # seq2 <- cbind(na2, seq2)
  D <- D$new(seq1, seq2, p1, p2, s)
  
  # calculate matrix for sequence alignment
  mat <- makeMatrix(seq1, seq2)
  mat <- initializeMat(mat, seq1, seq2, g1, g2, s)

  rowLen <- dim(seq1)[2]
  colLen <- dim(seq2)[2]
  
  for (i in 2:rowLen) {
    for (j in 2:colLen) {
      d <- D$getScore(mat, i, j, g1, g2)
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
  if (0) {
    s1 <- as.matrix(seq1[, 2:dim(seq1)[2]])
    if (dim(s1)[2] == 1) {
      s1 <- t(s1)
    }
    
    s2 <- as.matrix(seq2[, 2:dim(seq2)[2]])
    if (dim(s2)[2] == 1) {
      s2 <- t(s2)
    }
  }
  
  align1 <- matrix(seq1[, 1], nrow = dim(seq1)[1])
  align2 <- matrix(seq2[, 1], nrow = dim(seq2)[1])
  
  i <- j <- 2
  for (t in traceVec) {
    if(t == 0) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i + 1
      j <- j + 1
    } else if(t == 1) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, g2)
      i <- i + 1
    } else {
      align1 <- cbind(align1, g1)
      align2 <- cbind(align2, seq2[, j])
      j <- j + 1
    }
  }
  #print(mat)
  #print(seq1)
  #print(seq2)
  
  align <- list(NA, NA, NA, NA)
  names(align) <- c("seq1", "seq2", "multi", "score")
  align[["seq1"]] <- align1
  align[["seq2"]] <- align2
  align[["multi"]] <- rbind(align1, align2)
  align[["score"]] <- score
  
  return(align)
}
