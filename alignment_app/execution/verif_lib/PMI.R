#h(x,y)
h <- function(x,y,corpus)
{
  X <- x==corpus[1, ]
  Y <- y==corpus[2, ]
  Z <- X+Y
  f.xy <- length(Z[Z==2])
  
  return(f.xy)
}

# g(x)
g <- function(x,corpus)
{
  f.x <- length(corpus[corpus==x])
  
  return(f.x)
}

MakeCoMat <- function(corpus)
{
  seg.vec <- unique(c(corpus))
  row <- length(seg.vec)
  col <- length(seg.vec)
  co.mat <- matrix(0, row, col, dimnames = list(seg.vec, seg.vec))
  
  for (i in seg.vec) {
    for (j in seg.vec) {
      co.mat[i, j] <- co.mat[i, j]+h(i, j, corpus)
    }
  }
  return(co.mat)
}
