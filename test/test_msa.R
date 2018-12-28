.myfunc.env = new.env()
sys.source("data_processing/MakeFeatureList.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/RemoveFirst.R", envir = .myfunc.env)
sys.source("verification_multiple/BestFirst.R", envir = .myfunc.env)
sys.source("verification_multiple/Random.R", envir = .myfunc.env)
sys.source("verification_multiple/check_nwunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

test <- function(file)
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