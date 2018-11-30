DelDupSeq <- function(inputDir = "../Alignment/results/")
{
  filesList <- list.files(inputDir)
  outputFilesList <- gsub("\\..*$", ".rlt", filesList)
  
  filesList <- paste(inputDir, filesList, sep = "/")
  outputFilesList <- paste(inputDir, outputFilesList, sep = "/")
  
  z <- 1
  for (file in filesList) {
    print(file)
    x <- read.table(file)
    
    # make a vector of region name symbols
    regVec <- as.vector(x$V2)
    
    # make a sequence vector
    seqVec <- as.vector(x$V3)
    numSeq <- length(seqVec)
    
    # make sequences list
    seqList <- list()
    k <- 1
    for (i in 1:(numSeq/2)) {
      seqList[[i]] <- list(NA, NA)
      # 
      seqList[[i]][1] <- seqVec[k]
      k <- k + 1
      seqList[[i]][2] <- seqVec[k]
      k <- k + 1
    }
    
    # remove duplicate sequences
    bool <- duplicated(seqList)
    seqList <- seqList[bool]
    regVec <- regVec[bool]
    
    lenVec <- length(regVec)
    lenList <- length(seqList)
    
    print(lenList)
    
    if (0) {
      k <- 1
      # sink(outputFilesList[[z]], append = T)
      for (i in 1:lenList) {
        if ((i%%2) == 0) {
          print("by The Linguists")
          cat("\n")
        } else {
          print("by The Needleman-Wunsch")
          cat("\n")
        }
        print(paste(regVec[k], seqList[[i]][1], sep = ": "))
        k <- k + 1
        print(paste(regVec[k], seqList[[i]][2], sep = ": "))
        k <- k + 1
      }
    }
    # sink()
    #z <- z + 1
  }
}
