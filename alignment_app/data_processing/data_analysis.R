avg <- function(file)
{
  table <- read.table(file)
  row <- dim(table)[1]
  avg <- sum(table$V3)/row
  return(avg)
}

UpperAndLowerThan <- function(file1, file2, output)
{
  # read files
  table1 <- read.table(file1)
  table2 <- read.table(file2)
  
  # make output
  out.upper <- paste(output, "upper", sep = ".")
  out.lower <- paste(output, "lower", sep = ".")
  
  # get the table row
  row <- dim(table1)[1]
  
  i <- 1
  while (i<=row) {
    # get the region and matching rate
    region <- as.vector(table1$V2[[i]])
    tb1.rate <- round(as.vector(table1$V3[[i]]), digits = 3)
    tb2.rate <- round(as.vector(table2$V3[[i]]), digits = 3)
    # output the comparing results
    if (tb1.rate > tb2.rate) {
      sink(out.upper, append = T)
      print(paste(region, tb1.rate, tb2.rate), quote = F)
      sink()
    } 
    else if (tb1.rate < tb2.rate) {
      sink(out.lower, append = T)
      print(paste(region, tb1.rate, tb2.rate), quote = F)
      sink()
    }
    i <- i+1
  }
  
  return(0)
}

library(xtable)
MakeCompTB <- function(file)
{
  tb <- read.table(file)
  tb <- as.matrix(tb)[, -1]
  tb <- t(t(tb))
  output <- gsub("\\..*$", ".tex", file)
  
  sink(output)  
  print(xtable(tb))
  sink()
  
  return(0)
}
