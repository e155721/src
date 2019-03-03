source("data_processing/MakeWordList.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("msa/RemoveFirst.R")
source("msa/BestFirst.R")
source("msa/Random.R")

library(tictoc)

IR <- function(method, wordList, s)
{
  switch(method,
         "rf" = msa <- RemoveFirst(wordList, s),
         "bf" = msa <- BestFirst(wordList, s),
         "rd" = msa <- Random(wordList, s)
  ) 
  
  return(msa)
}

VerificationIR <- function(method, inFile, corFile, p, words)
{
  wordList <- MakeWordList(inFile)
  lenWordList <- length(wordList)
  # make scoring matrix and gap penalty
  s <- MakeFeatureMatrix(-10, p)
  
  # output the time of MSA execution
  if (!is.na(words)) {
    sink(paste(method, "-", words, ".time", sep = ""), append = T)
    tic(basename(inFile))
    msa <- IR(method, wordList, s)
    toc()
    sink()
  } else {
    msa <- IR(method, wordList, s)
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
  msa <- msa[order(msa[, 1]), ]
  corMat <- corMat[order(corMat[, 1]), ]
  
  # calculate matching rate
  count <- 0
  for (i in 1:nrow) {
    input <- paste(msa[i, ], collapse = "")
    correct <- paste(corMat[i, ], collapse = "")
    if (input == correct) {
      count <- count + 1
    }
  }
  
  matchingRate <- (count/nrow)*100
  if (matchingRate != 0) {
    write.table(msa, paste(basename(inFile), ".", p, ".", method, sep = ""))
    write.table(corMat, paste(basename(corFile), ".", p, ".", method, sep = ""))
  }
  return(matchingRate)
}
