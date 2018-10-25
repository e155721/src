.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

dirPath <- "../Alignment/correct_data/"
filesName <- list.files(dirPath)
inputFiles <- paste(dirPath, filesName, sep = "")

for (f in inputFiles) {
  wordList <- makeWordList(f)
  wRow <- length(wordList)
  wCol <- length(wordList[[1]])
  wordMatrix <- matrix(NA, wRow, wCol)

  for (i in 1:wRow) {
    wordMatrix[i, ] <- wordList[[i]]
  }
  
  matCol <- wCol
  j <- 1
  while (j <= matCol) {
    el <- regexpr("-", wordMatrix[, j])
    if (sum(el) == wRow) {
      wordMatrix <- wordMatrix[, -j]
      matCol <- dim(wordMatrix)[2]
    } else {
      j <- j + 1
    }
  }
  write.table(wordMatrix, paste(f, "txt", sep = "."))
}