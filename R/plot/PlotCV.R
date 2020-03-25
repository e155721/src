source("lib/load_phoneme.R")

PlotCV <- function(l1.mat, l2.mat, cv, p = 1) {
  
  if (cv == "c") {
    CV <- C
  } else {
    CV <- V
  }
  
  # Extract the elements of C or V.
  l1 <- l1.mat[c(CV, "-"), c(CV, "-"), p]
  l2 <- l2.mat[c(CV, "-"), c(CV, "-"), p]
  
  # Make the combination of C or V.
  comb <- combn(CV, 2)
  comb.dim <- dim(comb)[2]
  
  vec1 <- vec2 <- NULL
  for (i in 1:comb.dim) {
    vec1 <- c(vec1, l1[comb[1, i], comb[2, i]])
    vec2 <- c(vec2, l2[comb[1, i], comb[2, i]])
  }
  
  pair1 <- pair2 <- NULL
  val1  <- val2  <- NULL
  for (i in 1:comb.dim) {
    if (is.na(vec1[i])) {
      # NOP
    } else {
      pair1 <- pair2 <- c(pair1, paste(comb[1, i], comb[2, i]))
      val1  <- c(val1, vec1[i])
      val2  <- c(val2, vec2[i])
    }
  }
  
  # Plot the graphs.
  pdf(paste(cv, "_p", p, ".pdf", sep = ""))
  plot(val1, type = "l", col = "red", xlab = "", ylab = "", xaxt = "n", ylim = c(0, 7))
  par(new = T)
  plot(val2, type = "l", col = "blue", xlab = "Symbol Pair", ylab = paste("p", p, sep = ""), ylim = c(0, 7))
  legend("topleft", legend=c("L1", "L2"), col=c("red", "blue"), lty = 1)
  graphics.off()
  
  return(0)
}
