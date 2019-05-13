#f(x,y)
f <- function(x,y,corpus)
{
  col <- dim(corpus)[2]
  count <- 0
  for (j in 1:col) {
    if (corpus[1, j] == corpus[2, j]) {
      count <- count+1
    }
  }
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
  p1 <- f(x,y,corpus)
  if (x != y) {
    p1 <- p1 + f(y,x,corpus)
  }
  p1 <- p1*N
  # g(x), g(y)
  p2 <- g(x, corpus)*g(y, corpus)
  pmi <- log2(p1/p2)
  
  return(pmi)
}
