CheckScore <- function(x, s) {
  nrow <- dim(x)[1]
  ncol <- dim(x)[2]
  
  sp <- 0
  for (j in 2:ncol) {
    spVec <- x[, j]
    l <- 2
    len <- length(spVec)
    for (k in 1:(len-1)) {
      for (m in l:len) {
        sp <- sp + s[spVec[k], spVec[m]]
      }
      l <- l + 1
    }
  }
  return(sp)
}
