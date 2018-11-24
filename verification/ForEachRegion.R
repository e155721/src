ForEachRegion <- function(filesPath, ansratePath, comparePath)
{
  
  z <- 1
  # conduct the alignment for each files
  for (f in filesPath) {
    
    # make the word list
    wordList <- MakeWordList(f["input"])
    correct <- MakeWordList(f["correct"])
    
    # get the number of the regions
    regions <- length(wordList$vec)
    
    # make compare path
    #comparePath <- paste("../Alignment/compare-", z, sep = "")
    #print(comparePath)
    #z <- z + 1
        
    l <- 2
    count <- 0
    for (k in 1:(regions-1)) {
      # the start of the alignment for each the region pair
      for (i in l:regions) {
        correctMat <- RemkSeq(correct$list[[k]], correct$list[[i]])
        align <- NeedlemanWunsch(wordList$list[[k]], wordList$list[[i]], p1, p2, scoringMatrix)
        
        rltAln <- paste(paste(align$seq1, align$seq2, sep = ""), collapse = "")
        rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
        
        if (rltAln != rltCor) {
          sink(comparePath, append = T)
          cat("\n")
          #print("by The Needleman-Wunsch")
          print(paste(align$seq1, collapse = " "))
          print(paste(align$seq2, collapse = " "))
          
          cat("\n")
          #print("by The Linguists")
          print(paste(correctMat[1, ], collapse = " "))
          print(paste(correctMat[2, ], collapse = " "))
          sink()
        } else {
          count <- count + 1
        }
        
        if (0) {
          sink(outputPath, append = T)
          cat("\n")
          print("by The Needleman-Wunsch")
          print(paste(align$seq1))
          print(align$seq2)
          sink()
        }
      }
      # the end of the aligne for each the region pair
      l <- l + 1
    }
    
    # output the matching rate
    sink(ansratePath, append = T)
    matchingRate <- count / sum((regions-1):1) * 100
    rlt <- paste(f["name"], matchingRate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}