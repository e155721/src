ConvFreqMat <- function(mat.list, sym) {
  # mat.list: The list of matrix.
  # pair: The list of vector.
  
  sym.match <- rbind(sym, sym)
  sym.mismatch <- combn(sym, 2)
  sym.comb <- cbind(sym.match, sym.mismatch)
  N <- dim(sym.comb)[2]
  sym.vec <- paste(sym.comb[1, ], sym.comb[2, ])
  
  freq.all.list <- list()
  freq.reg.list <- list()
  for (i in 1:2) {
    freq.all.vec <- NULL
    freq.reg.mat <- NULL
    for (n in 1:N) {
      x <- sym.comb[, n][1]
      y <- sym.comb[, n][2]
      if (x == y) {
        freq.all.vec <- c(freq.all.vec, mat.list[[i]][x, y, 1])
        freq.reg.mat <- rbind(freq.reg.mat, mat.list[[i]][x, y, 2:22])
      } else {
        freq.all.vec <- c(freq.all.vec, mat.list[[i]][x, y, 1] + mat.list[[i]][y, x, 1])
        freq.reg.mat <- rbind(freq.reg.mat, mat.list[[i]][x, y, 2:22] + mat.list[[i]][y, x, 2:22])
      }
    }
    freq.all.list[[i]] <- freq.all.vec
    freq.reg.list[[i]] <- freq.reg.mat
  }
  
  # Make the frequency matrix.
  freq.mat <- cbind(freq.all.list[[1]], freq.all.list[[2]])
  dimnames(freq.mat) <- list(sym.vec, NULL)
  
  # Make the frequency matrices for each region.
  reg1.mat <- freq.reg.list[[1]]
  reg2.mat <- freq.reg.list[[2]]
  
  # Make the combination of the groups.
  match <- rbind(1:6, 1:6)
  mismatch <- combn(1:6, 2, simplify = T)
  groups.comb <- cbind(match, mismatch)
  groups.comb <- paste(groups.comb[1, ], groups.comb[2, ], sep = "")
  dimnames(reg1.mat) <- list(sym.vec, groups.comb)
  dimnames(reg2.mat) <- list(sym.vec, groups.comb)
  
  # sorting
  reg1.mat  <- reg1.mat[order(freq.mat[, 1]), ]
  reg2.mat  <- reg2.mat[order(freq.mat[, 1]), ]
  freq.mat <- freq.mat[order(freq.mat[, 1]), ]
  freq.mat.dim <- dim(freq.mat)
  
  # Compress the matrix of the frequency.
  diff     <- freq.mat[, 1] - freq.mat[, 2]
  freq.mat <- freq.mat[which(diff != 0), ]
  
  # Arrange the matrices of the frequency for each region.
  one      <- rep(1, 21)
  diff     <- (reg1.mat - reg2.mat) %*% one
  reg1.mat <- reg1.mat[which(diff != 0), ]
  reg2.mat <- reg2.mat[which(diff != 0), ]
  
  freq.o <- list(freq.mat, reg1.mat, reg2.mat)
  
  return(freq.o)
}
