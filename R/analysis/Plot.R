Plot <- function(hist.mat) {
  
  # Find a max value.
  hist.mat.col <- dim(hist.mat)[2]
  tmp <- list()
  max <- NULL
  for (j in 1:hist.mat.col) {
    tmp[[j]] <- as.vector(hist.mat[, j])
    max <- c(max, tmp[[j]])
  }
  max <- max(max)
  
  for (i in 1:hist.mat.col) {
    plot(tmp[[i]], type = "o", col = i, ylim = c(0, max))
    par(new = T)
  }
  par(new = F)
  
  return(0)
}
