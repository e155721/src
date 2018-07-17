source("needlemen_wuncsh/execution.R")

test <- function()
{
  a <- as.vector("A", "G", "C", "G")
  b <- as.vector("A", "G", "A", "C")
  
  a <- as.vector("kx", "u", "b", "i")
  b <- as.vector("kx", "u", "p")
  
  needlemanWuncsh(a,b) 
}
