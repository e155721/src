library(tictoc)
library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("verification_multiple/RemoveFirst.R")
source("verification_multiple/BestFirst.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")

TicRF <- function()
{
  wordList <- MakeWordList("../Alignment/input_data/014.dat")
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  tic()
  RemoveFirst(wordList, p, s)
  toc()
  return(0)
}

TicBF <- function()
{
  wordList <- MakeWordList("../Alignment/input_data/014.dat")
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  tic()
  BestFirst(wordList, p, s)
  toc()
  return(0)
}
