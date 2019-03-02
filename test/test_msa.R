source("data_processing/MakeWordList.R")
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
         "pa" = msa <- ProgressiveAlignment(wordList, p, s),
         "rf" = msa <- RemoveFirst(wordList, p, s),
         "bf" = msa <- BestFirst(wordList, p, s),
         "rd" = msa <- Random(wordList, p, s)
  )

  return(msa)
}

