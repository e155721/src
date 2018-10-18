makeGapComb <- function(min = 1, max = 1)
{
  num_list <- list()
  tmp <- list()
  
  num1 <- c(-max:-min)
  num2 <- c(-max:-min)
  
  k <- 1
  for (i in 1:min) {
    for (j in 1:min) {
      tmp[[1]] <- num1[i]
      tmp[[2]] <- num2[j]
      num_list[[k]] <- tmp
      k <- k + 1
    }
  }
  return(num_list)
}