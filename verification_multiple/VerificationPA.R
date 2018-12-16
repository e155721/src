.myfunc.env = new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/MakeCorMat.R", envir = .myfunc.env)
attach(.myfunc.env)

VerificationPA <- function(inFile, corFile, p, scoringMatrix)
{
  wordList <- MakeWordList(inFile)
  lenWordList <- length(wordList)
  paRlt <- ProgressiveAlignment(wordList, p, scoringMatrix)
  inputAlign <- paRlt$multi
  gtree <- paRlt$guide
  
  corWordList <- MakeWordList(corFile)
  corAlign <- MakeCorMat(corWordList, gtree)
  
  nrow <- dim(corAlign)[1]
  
  # calculate matching rate
  count <- 0
  for (i in 1:nrow) {
    input <- paste(inputAlign[i, ], collapse = "")
    correct <- paste(corAlign[i, ], collapse = "")
    if (input == correct) {
      count <- count + 1
    }
  }
  
  matchingRate <- (count/nrow)*100
  return(matchingRate)
}
