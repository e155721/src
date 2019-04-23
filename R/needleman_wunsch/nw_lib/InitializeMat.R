InitializeMat = function(x, seq1, seq2, g1, g2, s)
{
  len1 <- dim(x)[1]
  len2 <- dim(x)[2]
  
  x[1, 1, 1] <- 0
  x[1, 1, 2] <- 0
  
  x[, 1, 2] <- 1
  for (i in 2:len1) {
    prof1 <- as.matrix(seq1[, i])
    prof2 <- as.matrix(g2)
    sp <- SP(prof1, prof2, s)
    x[i, 1, 1] <- x[i-1, 1, 1] + sp
  }
  
  x[1, , 2]  <- -1
  for (j in 2:len2) {
    prof1 <- as.matrix(g1)
    prof2 <- as.matrix(seq2[, j]) 
    sp <- SP(prof1, prof2, s)
    x[1, j, 1] <- x[1, j-1, 1] + sp
  }
  x[1, 1, 2] <- 0
  
  return(x)
}