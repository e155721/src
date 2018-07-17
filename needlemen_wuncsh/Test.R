test <- function()
{
  source("needlemen_wuncsh/execution.R")
  
  a <- c("A", "G", "C", "G")
  b <- c("A", "G", "A", "C")
  
  a <- c("kx", "u", "b", "i")
  b <- c("kx", "u", "p")
  
  needlemanWuncsh(a,b) 
}