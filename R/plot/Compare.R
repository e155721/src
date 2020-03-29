source("lib/load_phoneme.R")

Compare <- function(l1.mat, l2.mat, cv) {
  
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
  
  pair1 <- NULL
  norm1  <- norm2  <- NULL
  for (i in 1:comb.dim) {
    if (is.na(vec1[[i]][1])) {
      # NOP
    } else {
      pair1 <- c(pair1, paste(comb[1, i], comb[2, i]))
      v1 <- vec1[[i]]
      v2 <- vec2[[i]]
      norm1  <- c(norm1, sum(abs(v1)))
      norm2  <- c(norm2, sqrt(sum(v2 * v2)))
    }
  }
  
  # Plot the graphs.
  pdf(paste(cv, "_norm.pdf", sep = ""))
  ymax <- max(norm1, norm2)
  plot(norm1, type = "l", col = "red", xlab = "", ylab = "", ylim = c(0, ymax))
  par(new = T)
  plot(norm2, type = "l", col = "blue", xlab = "Symbol Pair", ylab = "Norm", ylim = c(0, ymax))
  legend("topleft", legend=c("L1", "L2"), col=c("red", "blue"), lty = 1)
  graphics.off()
  
  norm1 <- -norm1
  norm2 <- -norm2
  max1 <- max(norm1)
  min1 <- min(norm1)
  max2 <- max(norm2)
  min2 <- min(norm2)
  score1 <- score2 <- NULL
  N <- length(norm1)
  for (i in 1:N) {
    score1[i] <- (norm1[i] - min1) / (max1 - min1)
    score2[i] <- (norm2[i] - min2) / (max2 - min2)
  }
  
  pdf(paste(cv, "_score.pdf", sep = ""))
  ymax <- max(norm1, norm2)
  plot(score1, type = "l", col = "red", xlab = "", ylab = "", ylim = c(0, 1))
  par(new = T)
  plot(score2, type = "l", col = "blue", xlab = "Symbol Pair", ylab = "Score", ylim = c(0, 1))
  legend("topleft", legend=c("L1", "L2"), col=c("red", "blue"), lty = 1, bg = "white")
  graphics.off()
  
  score.list <- list()
  score.list$pair <- pair1
  score.list$L1 <- score1
  score.list$L2 <- score2
  
  return(score.list)
}
