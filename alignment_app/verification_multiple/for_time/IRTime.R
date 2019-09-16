source("data_processing/MakeWordList.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("msa/RemoveFirst.R")
source("msa/BestFirst.R")
source("msa/Random.R")

library(tictoc)

IRTime <- function(method, inFile, words)
{
  wordList <- MakeWordList(inFile)
  lenWordList <- length(wordList)
  s <- MakeFeatureMatrix(-10, -3)
  
  # output the time of MSA execution
  # RF
  sink(paste(method, "-", words, ".time", sep = ""), append = T)
  tic(basename(inFile))
  switch(method,
         "rf" = msa <- RemoveFirst(wordList, s),
         "bf" = msa <- BestFirst(wordList, s),
         "rd" = msa <- Random(wordList, s)
  ) 
  toc()
  sink()
  
  return(0)
}
