MakeCompareTable <- function(file1, file2, out = NULL) {
  
  # load files
  tb1 <- read.table(file1)
  tb2 <- read.table(file2)
  
  # Make a separation line.
  regions <- tb1[, 1]
  sep <- matrix(" ", length(regions), 1)
  
  # Remove regions.
  tb1 <- tb1[, -1]
  tb2 <- tb2[, -1]
  
  # Remove the column names.
  colnames(regions) <- NULL
  colnames(sep) <- " "
  colnames(tb1) <- NULL
  colnames(tb2) <- NULL
  
  # Write the table.
  tb1 <- cbind(tb1, sep)
  comp <- cbind(tb1, tb2)
  comp <- cbind(regions, comp)
  
  if (is.null(out)) {
    write.csv(comp, "comp.csv")
  } else {
    write.csv(comp, paste(out, ".csv", sep = ""))
  }
  
  return(0)
}
