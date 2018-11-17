library(R6)

# this function makes matrix for sequence alignment
makeMatrix <- function(seq1, seq2)
{
  len1 <- length(seq1)
  len2 <- length(seq2)
  x <- array(dim=c(len1, len2, 2),
             dimnames = list(seq1, seq2))
  return(x)
}

# this function initialises matrix
InitializeMat <- function(x, p1, p2)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  x[1, 1, 1] <- 0
  x[1, 1, 2] <- 0
  
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
              p <- self$p1
              if (self$bp == T) {
                p <- self$p2
              }
              d1 <- x[i-1, j-1, 1] + self$s[self$seq1[i], self$seq2[j]]
              d2 <- x[i-1, j, 1] + p
              d3 <- x[i, j-1, 1] + p
              
              d <- list()
              d[[1]] <- max(d1, d2, d3)
              
              if (d[[1]] == d1) {
                d[[2]] <- 0 # (0,0)
                self$bp <- F
              } else if (d[[1]] == d3) {
                d[[2]] <- -1 # (-1,0)
                self$bp <- T
              } else if (d[[1]] == d2) {
                d[[2]] <- 1 # (0,1)
                self$bp <- T
              }
              
              return(d)
            }
          )
  )
