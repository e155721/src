normalized_rank <- function(i, mat, dist=T) {
  
  off.diag <- c(mat[upper.tri(mat)], mat[lower.tri(mat)])
  off.diag <- sort(off.diag)
  
  c.pair <- mat[i, i]
  
  comp.set <- c(c.pair, off.diag)
  
  if (dist) {
    nr <- sum(comp.set <= c.pair) / length(comp.set)
  } else {
    nr <- sum(comp.set >= c.pair) / length(comp.set) 
  }
  
  return(nr)
}

each_nr <- function(mat, dist=T) {
  N <- dim(mat)[1]
  
  nr.vec <- NULL
  for (i in 1:N) {
    nr.vec[i] <- normalized_rank(i, mat, dist)
  }
  
  concepts <- row.names(mat)
  names(nr.vec) <- concepts
  return(nr.vec)
}

Z <- function(nr.vec) {
  N <- length(nr.vec)
  z <- (sum(-log(nr.vec)) - N) / sqrt(N)
  return(z)
}

dist <- function(nr.vec) {
  
  N <- length(nr.vec)
  
  nr.max <- NULL
  nr.min <- NULL
  for (i in 1:N) {
    nr.max[i] <- 1 / (N * N - N + 1)
    nr.min[i] <- 1
  }
  
  z <- Z(nr.vec)
  z.max <- Z(nr.max)
  z.min <- Z(nr.min)

  d <- (z.max - z) / (z.max - z.min)
  return(d)
}
