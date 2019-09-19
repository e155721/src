# source("needleman_wunsch/nw_lib/D.R")
# source("needleman_wunsch/nw_lib/SP.R")

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
      
      d <- c(NA, NA)
      if ((i>2) && (j>2) && (i==j)) {
        d4 <- D$D4(mat, i, j)
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

SP <- function(prof1, prof2, s)
{
  # make profiles
  prof <- rbind(prof1, prof2)
  prof.len <- length(prof)
  len1 <- prof.len-1
  len2 <- prof.len
  
  sp <- 0
  l <- 2
  for (k in 1:len1) {
    for (m in l:len2) {
      sp <- sp + s[prof[k], prof[m]]
    }
    l <- l + 1
  }
  return(sp)
}

D <-
  R6Class("D",
          private = list(
            seq1 = NA,
            seq2 = NA,
            g1 = NA,
            g2 = NA,
            s = NA
          ),
          
          public = list(
            initialize = function(seq1, seq2, g1, g2, s)
            {
              private$seq1 <- seq1
              private$seq2 <- seq2
              private$g1 <- g1
              private$g2 <- g2
              private$s <- s
            },
            
            D1 = function(x, i, j)
            {
              # calculate D(i,j)
              prof1 <- as.matrix(private$seq1[, i])
              prof2 <- as.matrix(private$seq2[, j])
              sp <- SP(prof1, prof2, private$s)
              d1 <- x[i-1, j-1, 1] + sp
              
              return(d1)
            },
            
            D2 = function(x, i, j)
            {
              # vertical gap
              prof1 <- as.matrix(private$seq1[, i])
              prof2 <- as.matrix(private$g2)
              sp <- SP(prof1, prof2, private$s)
              d2 <- x[i-1, j, 1] + sp
              
              return(d2)
            },
            
            D3 = function(x, i, j)
            {
              # horizontally gap
              prof1 <- as.matrix(private$g1)
              prof2 <- as.matrix(private$seq2[, j])
              sp <- SP(prof1, prof2, private$s)
              d3 <- x[i, j-1, 1] + sp
              
              return(d3)
            },
            
            D4 = function(x, i, j)
            {
              # horizontally gap
              # cost for seq1[i] to seq2[j-1]
              prof1 <- as.matrix(private$seq1[, i])
              prof2 <- as.matrix(private$seq2[, j-1])
              sp1 <- SP(prof1, prof2, private$s)*2
              
              # cost for seq1[i-1] to seq2[j]
              prof1 <- as.matrix(private$seq1[, i-1])
              prof2 <- as.matrix(private$seq2[, j])
              sp2 <- SP(prof1, prof2, private$s)*2
              
              d4 <- x[i-2, j-2, 1] + 0.999 + sp1 + sp2
              
              return(d4)
            }
          )
  )
