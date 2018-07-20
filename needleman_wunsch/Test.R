test <- function()
{
  source("needleman_wunsch/NeedlemanWunsch.R")
  
  a <- c("kx", "u", "b", "i")
  b <- c("kx", "u", "p")
  
  needlemanWunsch(a,b, scoringMatrix)
}
