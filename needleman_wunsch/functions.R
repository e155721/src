library(R6)

# this function makes matrix for sequence alignment
makeMatrix <- function(seq1, seq2)
{
  len1 <- dim(seq1)[2]
  len2 <- dim(seq2)[2]
  x <- array(dim=c(len1, len2, 2))
  return(x)
}

initializeMat = function(x, g1, g2)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  x[1, 1, 1] <- 0
  x[1, 1, 2] <- 0
  
  x[, 1, 2] <- 1
  for (i in 2:len1) {
    prof1 <- as.matrix(seq1[, i])
    prof2 <- as.matrix(g2)
    sp <- sp(prof1, prof2)
    x[i, 1, 1] <- x[i-1, 1, 1] + sp
  }
  return(x)
}

SP <-
  R6Class("SP",
          public = list(
            s = NA
          ),
          
          initialize = function(s)
          {
            self$s <- s
          },
          
          sp = function(prof1, prof2)
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
                sp <- sp + self$s[prof[k], prof[m]]
              }
              l <- l + 1
            }
            return(sp)
          }
  )


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
            
            getScore = function(x, i, j, g1, g2)
            {
              # exchange the gap penalty
              p <- self$p1
              if (self$bp == T) {
                p <- self$p2
              }
              
              # calculate D(i,j)
              prof1 <- as.matrix(self$seq1[, i])
              prof2 <- as.matrix(self$seq2[, j])
              sp <- SP$sp(prof1, prof2)
              d1 <- x[i-1, j-1, 1] + sp
              # d1 <- x[i-1, j-1, 1] + self$s[self$seq1[i], self$seq2[j]]
              # d2 <- x[i-1, j, 1] + p
              # d3 <- x[i, j-1, 1] + p
              
              # vertical gap
              prof1 <- as.matrix(self$seq1[, i])
              prof2 <- as.matrix(g2)
              sp <- SP$sp(prof1, prof2)
              d2 <- x[i-1, j, 1] + sp
              
              # horizontally gap
              prof1 <- as.matrix(g1)
              prof2 <- as.matrix(self$seq2[, j])
              sp <- SP$sp(prof1, prof2)
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
