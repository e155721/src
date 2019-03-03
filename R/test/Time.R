library(tictoc)
library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("verification_multiple/RemoveFirst.R")
source("verification_multiple/BestFirst.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")

TimeRF <- function(file = "../Alignment/input_data/014.dat")
{
  wordList <- MakeWordList(file)
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  time.list <- foreach(i = 1:10) %dopar% {
    tic()
    RemoveFirst(wordList, p, s)
    toc()
  }
  
  time.vec <- unlist(time.list)
  time.ave <- sum(time.vec)/10
  print(paste("Time of RF:", time.ave))
  
  return(0)
}

TimeBF <- function(file = "../Alignment/input_data/014.dat")
{
  wordList <- MakeWordList(file)
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  time.list <- foreach(i = 1:10) %dopar% {
    tic()
    BestFirst(wordList, p, s)
    toc()
  }
  
  time.vec <- unlist(time.list)
  time.ave <- sum(time.vec)/10
  print(paste("Time of BF:", time.ave))
      
  return(0)
}
