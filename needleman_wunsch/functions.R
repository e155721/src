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
initializeMat <- function(x, p)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  x[1, 1, 1] <- 0
  x[1, 1, 2] <- 0
  
  g <- p
  for (i in 2:len1) {
    x[i, 1, 1] <- g
    x[i, 1, 2] <- 1
    g <- g + p
  }
  
  g <- p
  for (j in 2:len2) {
    x[1, j, 1] <- g
    x[1, j, 2] <- -1
    g <- g + p
  }
  
  return(x)
}

D <- 
  R6Class("D",
          public = list(
            seq1 = NA,
            seq2 = NA,
            p = NA,
            s = NA,
            
            initialize = function(seq1, seq2, p, s)
            {
              self$seq1 <- seq1
              self$seq2 <- seq2
              self$p <- p                
              self$s <- s
            },
            
            getScore = function(x, i, j)
            {
              d1 <- x[i-1, j-1, 1] + self$s[self$seq1[i], self$seq2[j]]
              d2 <- x[i-1, j, 1] + self$p
              d3 <- x[i, j-1, 1] + self$p
              
              d <- list()
              d[[1]] <- max(d1, d2, d3)
              
              if (d[[1]] == d1) {
                d[[2]] <- 0 # (0,0)
              } else if (d[[1]] == d2) {
                d[[2]] <- 1 # (0,1)
              } else {
                d[[2]] <- -1 # (-1,0)
              }
              
              return(d)
            }
          )
  )
