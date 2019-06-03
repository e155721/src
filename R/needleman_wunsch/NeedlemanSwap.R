source("needleman_wunsch/nw_lib/D.R")
source("needleman_wunsch/nw_lib/SP.R")

NeedlemanSwap <- function(seq1, seq2, s)
{
  # get the lengths of sequences
  lenSeq1 <- dim(seq1)[2]
  lenSeq2 <- dim(seq2)[2]
  
  # initialize variable
  g1 <- matrix("-", nrow = dim(seq1)[1])
  g2 <- matrix("-", nrow = dim(seq2)[1])
  D <- D$new(seq1, seq2, g1, g2, s)
  
  # making the distance matrix
  mat <- array(dim=c(lenSeq1, lenSeq2, 2))
  
  # initializing the distance matrix
  mat[1, 1, ] <- 0
  
  # vertical gap
  for (i in 2:lenSeq1) {
    mat[i, 1, 1] <- D$D2(mat, i, 1)
    mat[i, 1, 2] <- 1
  }
  
  # holiontally gap
  for (j in 2:lenSeq2) {
    mat[1, j, 1] <- D$D3(mat, 1, j)
    mat[1, j, 2] <- -1
  }
  
  # calculation the distance matrix
  for (i in 2:lenSeq1) {
    for (j in 2:lenSeq2) {
      
      d1 <- D$D1(mat, i, j)
      d2 <- D$D2(mat, i, j)
      d3 <- D$D3(mat, i, j)
      d4 <- D$D4(mat, i, j)
      
      d <- c(NA, NA)
      if ((i>2) && (j>2) && (i==j)
          && seq1[i]==seq2[j-1] && seq1[i-1]==seq2[j]) {
        d[1] <- min(d1, d2, d3, d4)
      } else {
        d[1] <- min(d1, d2, d3)
      }
      
      if (lenSeq1 <= lenSeq2) {
        if (d[1] == d3) {
          d[2] <- -1 # (-1,0)
        } else if (d[1] == d2) {
          d[2] <- 1 # (0,1)
        } else if (d[1] == d1) {
          d[2] <- 0 # (0,0)
        } else if ((d[1] == d4)) {
          print("swap")
          d[2] <- -2
        }
      }
      else if (lenSeq2 < lenSeq1) {
        if (d[1] == d2) {
          d[2] <- 1 # (0,1)
        } else if (d[1] == d3) {
          d[2] <- -1 # (-1,0)
        } else if (d[1] == d1) {
          d[2] <- 0 # (0,0)
        } else if ((d[1] == d4)) {
          print("swap")
          d[2] <- -2
        }
      }
      mat[i, j, 1:2] <- d
      
    }
  }
  
  # trace back
  trace <- c() 
  i <- lenSeq1
  j <- lenSeq2
  
  while (TRUE) {
    if (i == 1 && j == 1) break
    trace <- append(trace, mat[i, j, 2])
    path <- mat[i, j, 2]
    if (path == 0) {
      i <- i - 1
      j <- j - 1
    } else if (path == 1) {
      i <- i - 1
    } else if (path == -1) {
      j <- j - 1
    } else if (path == -2) {
      i <- i - 2
      j <- j - 2
    }
  }
  trace <- rev(trace)
  
  # make alignment
  align1 <- matrix(seq1[, 1], nrow = dim(seq1)[1])
  align2 <- matrix(seq2[, 1], nrow = dim(seq2)[1])
  
  i <- j <- 2
  for (t in trace) {
    if (t == 0) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i + 1
      j <- j + 1
    } else if (t == 1) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, g2)
      i <- i + 1
    } else if (t == -1) {
      align1 <- cbind(align1, g1)
      align2 <- cbind(align2, seq2[, j])
      j <- j + 1
    } else if (t == -2) {
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i + 1
      j <- j + 1
      align1 <- cbind(align1, seq1[, i])
      align2 <- cbind(align2, seq2[, j])
      i <- i + 1
      j <- j + 1
    }
  }
  
  align <- list(NA, NA)
  align[[1]] <- align1
  align[[2]] <- align2
  
  # return
  rlt <- list(NA, NA, NA, NA)
  names(rlt) <- c("seq1", "seq2", "multi", "score")
  rlt[["seq1"]] <- align[[1]]
  rlt[["seq2"]] <- align[[2]]
  rlt[["multi"]] <- rbind(align[[1]], align[[2]])
  rlt[["score"]] <- mat[lenSeq1, lenSeq2, 1]
  
  return(rlt)
}
