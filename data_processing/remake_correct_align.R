.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

source("verification_multiple/DelGap.R")

dirPath <- "../Alignment/correct_data/"
filesName <- list.files(dirPath)
inputFiles <- paste(dirPath, filesName, sep = "")

for (f in inputFiles) {
  wordList <- MakeWordList(f)
  nrow <- length(wordList)
  ncol <- length(wordList[[1]])
  wordMat <- matrix(NA, nrow, ncol)
  
  for (i in 1:nrow) {
    wordMat[i, ] <- wordList[[i]]
  }
  
  # remove the columns that are composed only gaps
  wordMat <- DelGap(wordMat)
  
  write.table(wordMat, f)
}