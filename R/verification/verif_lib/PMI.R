#f(x,y)
f <- function(x,y,corpus)
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

PMI <- function(x,y,corpus)
{
  N <- length(corpus)
  
  # f(x,y)  
  p1 <- f(x,y,corpus)*N
  # g(x), g(y)
  p2 <- g(x, corpus)*g(y, corpus)
  pmi <- log2(p1/p2)
  
  return(pmi)
}
