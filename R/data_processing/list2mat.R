list2mat <- function(x.list)
{
  nrow <- length(x.list)
  
  ncol <- list()
  for (i in 1:nrow) {
    ncol[[i]] <- length(x.list[[i]])
  }
  ncol <- max(unlist(ncol))
  
  x.mat <- matrix(" ", nrow, ncol)
  for (i in 1:nrow) {
    x.mat[i, 1:length(x.list[[i]])] <- x.list[[i]]
  }
  
  return(x.mat)
}
