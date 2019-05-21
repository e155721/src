#h(x,y)
h <- function(x,y,corpus)
{
  X <- x==corpus[1, ]
  Y <- y==corpus[2, ]
  Z <- X+Y
  count <- length(Z[Z==2])
  
  return(count)
}

# g(x)
g <- function(x,corpus)
{
  nx1 <- length(corpus[1, corpus[1,]==x])
  nx2 <- length(corpus[2, corpus[2,]==x])
  
  return(nx1+nx2)
}

MakeCoMat <- function(corpus)
{
  seg.vec <- unique(c(corpus))
  row <- length(seg.vec)
  col <- length(seg.vec)
  co.mat <- matrix(0, row, col, dimnames = list(seg.vec, seg.vec))
  
  for (i in seg.vec) {
    for (j in seg.vec) {
      if (i!=j) {
        co.mat[i, j] <- co.mat[i, j]+h(i, j, corpus)
      }
    }
  }
  return(co.mat)
}
