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
    for (i in 1:(numSeq/2)) {
      seqList[[i]] <- list(seqVec[k], seqVec[k+1])
      regList[[i]] <- list(regVec[k], regVec[k+1])
      k <- k + 2
    }
    
    # remove duplicate sequences
    bool <- duplicated(seqList)
    
    if (sum(bool) != 0) {
      seqList <- seqList[!bool]      
      regList <- regList[!bool]
    }
    
    lenRegList <- length(regList)
    lenSeqList <- length(seqList)
    
    k <- 1
    sink(outputFilesList[[z]], append = T)
    for (i in 1:lenSeqList) {
      if ((i%%2) != 0) {
        cat("\n")
        print("by The Linguists")
      } else {
        cat("\n")
        print("by The Needleman-Wunsch")
      }
      print(paste(regList[[i]][1], seqList[[i]][1], sep = ": "))
      k <- k + 1
      print(paste(regList[[i]][2], seqList[[i]][2], sep = ": "))
      k <- k + 1
    }
    sink()
    z <- z + 1
  }
}
