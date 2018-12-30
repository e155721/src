library(tictoc)
library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("verification_multiple/RemoveFirst.R")
source("verification_multiple/BestFirst.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")

wordList <- MakeWordList("../Alignment/input_data/014.dat")
p <- -4
s <- MakeFeatureMatrix(-10, p)

TicRF <- function()
{
  wordList <- MakeWordList("../Alignment/input_data/014.dat")
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  tic()
  print(paste("RF:", RemoveFirst(wordList, p s)))
  toc()
  return(0)
}

TicBF <- function()
{
  wordList <- MakeWordList("../Alignment/input_data/014.dat")
  p <- -4
  s <- MakeFeatureMatrix(-10, p)
  
  tic()
  print(paste("BF:", BestFirst(wordList, p s)))
  toc()
  return(0)
}

TicMSA <- function(i)
{
  switch (i,
    1 = TicRF(),
    2 = TicBF()
  )  
  return(0)
}

foreach(i = 1:2) %dopar% {
  TicMSA(i)
}