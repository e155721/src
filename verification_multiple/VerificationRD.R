
source("data_processing/MakeWordList.R")
source("verification_multiple/Random.R")


VerificationRD <- function(inFile, corFile, p, s, words)
{
  wordList <- MakeWordList(inFile)
  lenWordList <- length(wordList)
  
  # output the time of MSA execution
  if (!is.na(words)) {
    sink(paste("rd-", words, ".time", sep = ""), append = T)
    tic(basename(inFile))
    paMat <- Random(wordList, p, s)
    toc()
    sink()
  } else {
    paMat <- Random(wordList, p, s)
  }
  
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
  if (matchingRate == 0) {
    write.table(paMat, paste(basename(inFile), ".", p, ".rd", sep = ""))
  }
  return(matchingRate)
}
