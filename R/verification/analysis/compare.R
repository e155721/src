# Wednesday, November 20th, 2019
source("lib/load_data_processing.R")

Compare <- function (f1, f2, out=NULL) {
  # Compare the two matching rate files.
  #
  # Args:
  #   f1, f2: The matching rate files.
  #
  # Returns:
  #   There is no returns.
  tb1 <- read.table(f1)
  tb2 <- read.table(f2)
  N <- dim(tb1)[1]
  
  # Finds the number of words that are higher or lower matching rates.
  
  upper.list <- list()
  lower.list <- list()
  
  upper <- 0
  lower <- 0
  for (i in 1:N) {
    
    diff <- abs(tb1[i, 2] - tb2[i, 2])
    comp <- paste(as.character(tb1$V1[i]), tb1[i, 2], tb2[i, 2], diff)    
    
    if (tb1$V2[i] > tb2$V2[i]) {
      upper <- upper + 1
      upper.list <- c(upper.list, comp)
    }
    
    if (tb1$V2[i] < tb2$V2[i]) {
      lower <- lower + 1
      lower.list <- c(lower.list, comp)
    }
    
  }
  
  f1.base <- basename(f1)
  f2.base <- basename(f2)
  upper.list[[length(upper.list) + 1]] <- paste(f1.base, ">", f2.base, upper)
  lower.list[[length(lower.list) + 1]] <- paste(f1.base, "<", f2.base, lower)
  
  # Print the results.
  print("Upper")
  print(upper.list)
  
  print("Lower")
  print(lower.list)
  
  # Output the results.
  if (length(upper.list) == 0)
    upper.list <- 0
  if (length(lower.list) == 0)
    lower.list <- 0
  write.table(list2mat(upper.list), paste("upper", out, ".txt", sep=""), quote=F)
  write.table(list2mat(lower.list), paste("lower", out, ".txt", sep=""), quote=F)
  
  return(0)
}
