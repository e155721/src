source("data_processing/MakeFeatureList.R")
source("data_processing/MakeWordList.R")
source("verification_multiple/ProgressiveAlignment.R")
source("verification_multiple/RemoveFirst.R")
source("verification_multiple/BestFirst.R")
source("verification_multiple/Random.R")
source("verification_multiple/check_nwunsch.R")

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
