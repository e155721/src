source("data_processing/MakeWordList.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("msa/ProgressiveAlignment.R")
source("msa/RemoveFirst.R")
source("msa/BestFirst.R")
source("msa/Random.R")

test <- function(file, method)
{
  wordList <- MakeWordList(file)
  p <- -3
  s <- MakeFeatureMatrix(-10, p)
  
  switch(method,
         "pa" = msa <- ProgressiveAlignment(wordList, s),
         "rf" = msa <- RemoveFirst(wordList, s),
         "bf" = msa <- BestFirst(wordList, s),
         "rd" = msa <- Random(wordList, s)
  )
  
  return(msa)
}

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

file <- "../../Alignment/input_data/002.input"
test(file, "bf")
