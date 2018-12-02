DelDupSeq <- function(inputDir = "../Alignment/results/")
{
  filesList <- list.files(inputDir)
  outputFilesList <- gsub("\\..*$", ".rlt", filesList)
  
  filesList <- paste(inputDir, filesList, sep = "/")
  outputFilesList <- paste(inputDir, outputFilesList, sep = "/")
  
  z <- 1
  for (file in filesList) {
    x <- read.table(file)
    
    # make a vector of region name symbols
    regVec <- as.vector(x$V2)
    
    # make a sequence vector
    seqVec <- as.vector(x$V3)
    numSeq <- length(seqVec)
    
    # make sequences list
    seqList <- list()
    regList <- list()
    k <- 1
    for (i in 1:(numSeq/4)) {
      seqList[[i]] <- list(seqVec[k], seqVec[k+1], seqVec[k+2], seqVec[k+3])
      regList[[i]] <- list(regVec[k], regVec[k+1], regVec[k+2], regVec[k+3])
      k <- k + 4
    }
    
    # remove duplicate sequences
    bool <- duplicated(seqList)
    
    # before duplicated()
    sink(outputFilesList[[z]], append = T)
    print(paste("Mismatch Frequency:", length(seqList), sep = " "))
    sink()
    
    if (sum(bool) != 0) {
      seqList <- seqList[!bool]      
      regList <- regList[!bool]
    }
    
    lenRegList <- length(regList)
    lenSeqList <- length(seqList)
    
    # after duplicated()
    sink(outputFilesList[[z]], append = T)
    print(paste("Mismatch Frequency:", lenSeqList, sep = " "))
    sink()
    
    sink(outputFilesList[[z]], append = T)
    print(paste("Miss:", lenSeqList))
    sink()
    k <- 1
    sink(outputFilesList[[z]], append = T)
    for (i in 1:lenSeqList) {
      cat("\n")
      print("by The Linguists")
      print(paste(regList[[i]][1], seqList[[i]][1], sep = ": "))
      k <- k + 1
      print(paste(regList[[i]][2], seqList[[i]][2], sep = ": "))
      k <- k + 1
      
      cat("\n")
      print("by The Needleman-Wunsch")
      print(paste(regList[[i]][3], seqList[[i]][3], sep = ": "))
      k <- k + 1
      print(paste(regList[[i]][4], seqList[[i]][4], sep = ": "))
      k <- k + 1
    }
    sink()
    z <- z + 1
  }
}
