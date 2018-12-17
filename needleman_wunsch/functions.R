library(R6)

# this function makes matrix for sequence alignment
makeMatrix <- function(seq1, seq2)
{
  len1 <- dim(seq1)[2]
  len2 <- dim(seq2)[2]
  x <- array(dim=c(len1, len2, 2))
  return(x)
}

# this function initialises matrix
InitializeMat <- function(x, p1, p2)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  x[, 1, 1] <- 0
  x[, 1, 2] <- 1
  
  x[1, , 1] <- 0
  x[1, , 2] <- -1
  x[1, 1, 2] <- 0
  
  if (0) {
    g <- p1
    for (i in 2:len1) {
      x[i, 1, 1] <- g
      x[i, 1, 2] <- 1
      g <- g + p2
    }
    
    g <- p1
    for (j in 2:len2) {
      x[1, j, 1] <- g
      x[1, j, 2] <- -1
      g <- g + p2
    }
  }
  
  return(x)
}

D <- 
  R6Class("D",
          public = list(
            seq1 = NA,
            seq2 = NA,
            p1 = NA,
            p2 = NA,
            s = NA,
            bp = F,
            
            initialize = function(seq1, seq2, p1, p2, s)
            {
              self$seq1 <- seq1
              self$seq2 <- seq2
              self$p1 <- p1
              self$p2 <- p2
              self$s <- s
            },
            
            getScore = function(x, i, j)
            {
              # exchange the gap penalty
              p <- self$p1
              if (self$bp == T) {
                p <- self$p2
              }
              
              if (0) {
                spVec <- append(self$seq1[, i], self$seq2[, j])
                sp <- 0
                l <- 2
                len <- length(spVec)
                for (k in 1:(len-1)) {
                  for (m in l:len) {
                    sp <- sp + self$s[spVec[k], spVec[m]]
                  }
                  l <- l + 1
                }
              }
              
              prof1 <- as.vector(self$seq1[, i])
              prof2 <- as.vector(self$seq2[, j])
              sp <- 0
              len1 <- length(prof1)
              len2 <- length(prof2)
              for (k in 1:len1) {
                for (m in 1:len2) {
                  sp <- sp + self$s[prof1[k], prof2[m]]
                }
              }
              d1 <- x[i-1, j-1, 1] + sp
              # d1 <- x[i-1, j-1, 1] + self$s[self$seq1[i], self$seq2[j]]
              # d2 <- x[i-1, j, 1] + p
              # d3 <- x[i, j-1, 1] + p
              
              sp <- 0
              lp <- length(self$seq2[, j])
              for (k in 1:lp) {
                for (m in self$seq1[, i]) {
                  sp <- sp + self$s[m, "-"]
                }
              }
              d2 <- x[i-1, j, 1] + sp
              
              sp <- 0
              lp <- length(self$seq1[, i])
              for (k in 1:lp) {
                for (m in self$seq2[, j]) {
                  sp <- sp + self$s[m, "-"]
                }
              }
              d3 <- x[i, j-1, 1] + sp
              
              d <- c(NA, NA)
              d[1] <- max(d1, d2, d3)
              
              lenSeq1 <- length(self$seq1)
              lenSeq2 <- length(self$seq2)
              
              if (lenSeq1 <= lenSeq2) {
                if (d[1] == d3) {
                  d[2] <- -1 # (-1,0)
                  self$bp <- T
                } else if (d[1] == d2) {
                  d[2] <- 1 # (0,1)
                  self$bp <- T
                } else if (d[1] == d1) {
                  d[2] <- 0 # (0,0)
                  self$bp <- F
                }
              }
              else if (lenSeq2 < lenSeq1) {
                if (d[1] == d2) {
                  d[2] <- 1 # (0,1)
                  self$bp <- T
                } else if (d[1] == d3) {
                  d[2] <- -1 # (-1,0)
                  self$bp <- T
                } else if (d[1] == d1) {
                  d[2] <- 0 # (0,0)
                  self$bp <- F
                }
              }
              
              return(d)
            }
          )
  )
