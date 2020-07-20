library(foreach)
library(doParallel)
registerDoParallel(detectCores())

#source("needleman_wunsch/functions.R")
#source("needleman_wunsch/NeedlemanWunsch.R")
#source("needleman_wunsch/MakeFeatureMatrix.R")
#source("data_processing/MakeWordList.R")

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
