source("needleman_wunsch/nw_lib/functions.R")

NeedlemanWunsch <- function(seq1, seq2, s, fmin=F)
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
      mat[i, j, 1:2] <- MaxD(d1, d2, d3, lenSeq1, lenSeq2, fmin)
    }
  }
  
  # trace back
  align <- TraceBack(mat, seq1, seq2, g1, g2)
  
  rlt <- list(NA, NA, NA, NA)
  names(rlt) <- c("seq1", "seq2", "multi", "score")
  rlt[["seq1"]] <- align[[1]]
  rlt[["seq2"]] <- align[[2]]
  rlt[["multi"]] <- rbind(align[[1]], align[[2]])
  rlt[["score"]] <- mat[lenSeq1, lenSeq2, 1]
  
  return(rlt)
}
