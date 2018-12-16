.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

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
  
  j <- 1
  while (j <= dim(wordMat)[2]) {
    m <- match(wordMat[, j], "-")
    m <- !is.na(m)
    if (sum(m) == nrow) {
      wordMat <- wordMat[, -j]
    }
    j <- j + 1
  }
  
  write.table(wordMat, f)
}