ConvHistMat <- function(mat.list) {
  
  list.len <- length(mat.list)
  
  for (i in 1:list.len) {
    mat.list[[i]] <- as.vector(mat.list[[i]])
  }
  
  hist.mat <- rbind(mat.list[[1]])
  for (i in 2:list.len) {
    hist.mat <- rbind(hist.mat, mat.list[[i]])
  }
  hist.mat <- t(hist.mat)
  hist.mat <- hist.mat[order(hist.mat[, 1]), ]
  
  hist.mat.dim <- dim(hist.mat)
  hist.mat.new <- matrix(NA, 1, hist.mat.dim[2])
  for (i in 1:hist.mat.dim[1]) {
    if (sum(hist.mat[i, ]) == 0) {
      # NOP
    } else {
      hist.mat.new <- rbind(hist.mat.new, hist.mat[i, ])
    }
  }
  hist.mat <- hist.mat.new[-1, ]
  #hist.mat.dim <- dim(hist.mat)
  
  return(hist.mat)
}

hist.mat <- ComvHistmat(list(s.pmi[C, C], s.lg[C, C]))
