test <- function()
{
  source("needlemen_wuncsh/execution.R")
  
  a <- c("A", "G", "C", "G")
  b <- c("A", "G", "A", "C")
  
  needlemanWuncsh(a,b) 
}