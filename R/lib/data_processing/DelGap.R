DelGap <- function(x) {
  d.vec <- c()
  j <- 1
  while (j <= dim(x)[2]) {
    g.vec <- grep("-", x[, j])
    if (dim(x)[1] == length(g.vec)) {
      d.vec <- append(d.vec, j)
    }
    j <- j + 1
  }
  
  d.vec <- rev(d.vec)
  for (j in d.vec) {
    x <- x[, -j, drop = F]
  }
  
  return(x)
}
