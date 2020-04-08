ConvHistMat <- function(mat.list, sym) {
  # mat.list: The list of matrix.
  # pair: The list of vector.
  
  list.len <- length(mat.list)
  
  sym.match <- rbind(sym, sym)
  sym.combn <- combn(sym, 2)
  sym.combn <- cbind(sym.match, sym.combn)
  N <- dim(sym.combn)[2]
  sym.vec <- paste(sym.combn[1, ], sym.combn[2, ])
  
  vec.list <- list()
  reg.list <- list()
  for (i in 1:list.len) {
    vec <- NULL
    reg <- NULL
    for (n in 1:N) {
      x <- sym.combn[, n][1]
      y <- sym.combn[, n][2]
      if (x == y) {
        vec <- c(vec, mat.list[[i]][x, y, 1])
        reg <- rbind(reg, mat.list[[i]][x, y, 2:8])
      } else {
        vec <- c(vec, mat.list[[i]][x, y, 1] + mat.list[[i]][y, x, 1])
        reg <- rbind(reg, mat.list[[i]][x, y, 2:8] + mat.list[[i]][y, x, 2:8])
      }
    }
    vec.list[[i]] <- vec
    dimnames(reg) <- list(sym.vec, NULL)
    reg.list[[i]] <- reg
  }
  
  hist.mat <- cbind(vec.list[[1]])
  for (j in 2:list.len) {
    hist.mat <- cbind(hist.mat, vec.list[[j]])
  }
  dimnames(hist.mat) <- list(sym.vec, NULL)
  hist.mat <- hist.mat[order(hist.mat[, 1]), ]
  hist.mat.dim <- dim(hist.mat)
  
  diff <- hist.mat[, 1] - hist.mat[, 2:hist.mat.dim[2]]
  hist.mat <- hist.mat[which(diff != 0), ]
  
  freq.o <- list(hist.mat, reg.list)
  
  return(freq.o)
}
