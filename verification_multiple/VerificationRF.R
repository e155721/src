.myfunc.env = new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("verification_multiple/RemoveFirst.R", envir = .myfunc.env)
attach(.myfunc.env)

VerificationRF <- function(inFile, corFile, p, scoringMatrix)
{
  wordList <- MakeWordList(inFile)
  lenWordList <- length(wordList)
  paMat <- RemoveFirst(wordList, p, scoringMatrix)
  
  # make the correct words matrix
  corWordList <- MakeWordList(corFile)
  nrow <- length(corWordList)
  ncol <- dim(corWordList[[1]])[2]
  corMat <- matrix(NA, nrow, ncol)
  for (i in 1:nrow) {
    corMat[i, ] <- corWordList[[i]]
  }
  
  # sort by order the region  
  paMat <- paMat[order(paMat[, 1]), ]
  corMat <- corMat[order(corMat[, 1]), ]
  
  # calculate matching rate
  count <- 0
  for (i in 1:nrow) {
    input <- paste(paMat[i, ], collapse = "")
    correct <- paste(corMat[i, ], collapse = "")
    if (input == correct) {
      count <- count + 1
    }
  }
  
  matchingRate <- (count/nrow)*100
  return(matchingRate)
}
