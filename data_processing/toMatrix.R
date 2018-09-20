toMatrix <- function(data_table)
{
  d <- dim(data_table)
  mat <- matrix(NA, d[1], d[2])
  for (i in 1:d[2]) {
    mat[, i] <- as.vector(data_table[, i])
  }
  return(mat)  
}