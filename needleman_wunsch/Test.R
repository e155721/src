source("needleman_wunsch/NeedlemanWunsch.R")

test <- function()
{
  a <- c("A", "G", "C", "G")
  b <- c("A", "G", "A", "C")
  
  a <- c("kx", "u", "b", "i")
  b <- c("kx", "u", "p")
  
  needlemanWunsch(a,b) 
}
