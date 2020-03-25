source("lib/load_phoneme.R")

PlotL1 <- function(l1.mat, l2.mat, cv) {
  
  if (cv == "c") {
    CV <- C
  } else {
    CV <- V
  }
  
  # Extract the elements of C or V.
  l1 <- l1.mat[c(CV, "-"), c(CV, "-"), ]
  l2 <- l2.mat[c(CV, "-"), c(CV, "-"), ]
  
  # Make the combination of C or V.
  comb <- combn(CV, 2)
  comb.dim <- dim(comb)[2]
  
  vec1 <- vec2 <- list()
  for (i in 1:comb.dim) {
    vec1[[i]] <- l1[comb[1, i], comb[2, i], ]
    vec2[[i]] <- l2[comb[1, i], comb[2, i], ]
  }
  
  pair1 <- pair2 <- NULL
  norm1  <- norm2  <- NULL
  for (i in 1:comb.dim) {
    if (is.na(vec1[[i]][1])) {
      # NOP
    } else {
      pair1 <- pair2 <- c(pair1, paste(comb[1, i], comb[2, i]))
      v1 <- vec1[[i]]
      v2 <- vec2[[i]]
      norm1  <- c(norm1, sum(abs(v1)))
      norm2  <- c(norm2, sum(abs(v2)))
    }
  }
  
  # Plot the graphs.
  plot(norm1, type = "l", col = "red", xlab = "", ylab = "", xaxt = "n")
  par(new = T)
  plot(norm2, type = "l", col = "blue", xlab = "Symbol Pair", ylab = "Norm")
  
  return(0)
}
