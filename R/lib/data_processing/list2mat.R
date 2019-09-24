list2mat <- function(x.list, space=T)
{
  # Converts from a list to a matrix.
  #
  # Args:
  #   x.list: the list.
  # Returns:
  #   A matrix.
  nrow <- length(x.list)
  
  ncol <- list()
  for (i in 1:nrow) {
    ncol[[i]] <- length(x.list[[i]])
  }
  ncol <- max(unlist(ncol))
  
  if (isTRUE(space)) {
    x.mat <- matrix(" ", nrow, ncol)
  } else {
    x.mat <- matrix(NA, nrow, ncol)
  }
  for (i in 1:nrow) {
    x.mat[i, 1:length(x.list[[i]])] <- x.list[[i]]
  }
  
  return(x.mat)
}
