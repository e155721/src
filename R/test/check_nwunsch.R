
source("needleman_wunsch/functions.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")


library(foreach)
library(doParallel)
registerDoParallel(detectCores())

CheckScore <- function(x)
{
  nrow <- dim(x)[1]
  ncol <- dim(x)[2]
  
  sp <- 0
  for (j in 2:ncol) {
    spVec <- x[, j]
    l <- 2
    len <- length(spVec)
    for (k in 1:(len-1)) {
      for (m in l:len) {
        sp <- sp + scoringMatrix[spVec[k], spVec[m]]
      }
      l <- l + 1
    }
  }
  return(sp)
}

path <- "../Alignment/input_data/"
files <- list.files(path)
files <- paste(path, files, sep = "")

CheckNwunsch <- function(f)
{
  wordList <- MakeWordList(f)
  wl.len <- length(wordList)
  s <- MakeFeatureMatrix(-10, -3)
  
  seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s)
  
  if (wl.len >= 3) {
    for (i in 3:wl.len) {
      seq1 <- NeedlemanWunsch(seq1$multi, wordList[[i]], s)
    }
  }
  if (seq1$score != tmp(seq1$multi)) {
    print(f)
  }
  return(0)
}

foreach(f = files) %dopar% {
  CheckNwunsch(f)
}
