# these codes make scoring matrix
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

# this code defines gap penalty
p <- -2

# these codes receive input sequences
seq1 <- c(NA, "A", "G", "C", "G")
seq2 <- c(NA, "A", "G", "A", "C")

# this function makes matrix for sequence alignment
makeMatrix <- function(seq1, seq2)
{
  len1 <- length(seq1)
  len2 <- length(seq2)
  x <- array(dim=c(len1, len2, 2),
             dimnames = list(seq1, seq2))
  #x <- matrix(nrow = len1, ncol = len2, 
  #              dimnames = list(seq1, seq2))
  return(x)
}

# this function initialises matrix
initializeMat <- function(x, p)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  g <- 0
  for (i in 1:len1) {
    x[i, 1, 1] <- g
    g <- g + p
  }
  
  g <- 0
  for (i in 1:len2) {
    x[1, i, 1] <- g
    g = g + p
  }
  
  return(x)
}

# this function's aruguments range are greater than equal 2
s <- function(i,j)
{
  x <- seq1[i]
  y <- seq2[j]
  score <- scoringMatrix[x,y]
  
  return(score)
}

# this function's aruments range are greater than equal 2
D <- function(x, i, j, p)
{
  d1 <- x[i-1, j-1, 1] + s(i, j)
  d2 <- x[i-1, j, 1] + p
  d3 <- x[i, j-1, 1] + p
  
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