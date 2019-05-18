TraceBack <- function(x, seq1, seq2, g1, g2)
{
  len1 <- dim(seq1)[2]
  len2 <- dim(seq2)[2]
  
  # trace back
  score <- traceVec <- c() 
  i <- len1
  j <- len2
  n <- 1
  score <- x[i, j, 1]
  while (TRUE) {
    if (i == 1 && j == 1) break
    traceVec[n] <- x[i, j, 2]
    n <- n + 1
    
    trace <- x[i, j, 2]
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
  
  # make alignment
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
  
  align <- list(NA, NA)
  align[[1]] <- align1
  align[[2]] <- align2
  
  return(align)
}