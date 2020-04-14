options(digits=22)

ColSim <- function(col.gs, col.ga) {
  # Calculate the column similarity.
  #
  # Args:
  #   col.gs: A column of GS.
  #   col.ga: A column of GA.
  #
  # Return:
  #  cs: The column similarity.
  
  match <- sum(col.gs == col.ga)
  cs <- match / dim(col.ga)[1]
  #cs <- floor(cs * 1e+04) * 1e-04
  
  return(cs)
}

CDE <- function(file1, file2) {
  # Calculate the CDE score of the selected MSA.
  # 
  # Args:
  #   file1: A file of a gold standard MSA.
  #   file2: A file of a generated standard MSA.
  #
  # Return:
  #   cde: A list of the CDE score and the number of the perfect overlap columns.
  
  # Gold standard alignment
  GS   <- read.table(file1)
  GS   <- as.matrix(GS)
  gs.col <- dim(GS)[2]
  GS   <- GS[, 2:gs.col]
  gs.col <- gs.col - 1
  
  # Generated alignment
  GA   <- read.table(file2)
  GA   <- as.matrix(GA)
  ga.col <- dim(GA)[2]
  GA   <- GA[, 2:ga.col]
  ga.col <- ga.col - 1
  
  j <- 0
  cs.vec <- NULL
  for (i in 1:gs.col) {
    
    if (j == ga.col) {
      break
    }
    else if ((j + 1) == ga.col) {
      cs1 <- ColSim(GS[, i, drop=F], GA[, (j + 1), drop=F])
      cs.vec <- c(cs.vec, cs1)
      break
    } else {
      cs1 <- ColSim(GS[, i, drop=F], GA[, (j + 1), drop=F])
      cs2 <- ColSim(GS[, i, drop=F], GA[, (j + 2), drop=F])
      cs.vec <- c(cs.vec, max(cs1, cs2)[1])
      # Decide the index of the matched column.
      if (cs1 >= cs2) {
        j <- j + 1
      } else {
        j <- j + 2
      }
    }
  }
  
  cde         <- list()
  cde$score   <- sum(cs.vec) / ga.col
  cde$perfect <- sum(cs.vec == 1)
  
  return(cde)
}
