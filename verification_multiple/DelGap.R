DelGap <- function(x)
{
  j <- 1
  while (j <= dim(x)[2]) {
    g.vec <- grep("-", x[, j])
    if (dim(x)[1] == length(g.vec)) {
      x <- x[, -j]
    }
    j <- j + 1
  }
  return(x)
}
