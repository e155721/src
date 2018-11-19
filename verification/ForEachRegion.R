ForEachRegion <- function(filesPath, ansratePath, comparePath)
{
  # conduct the alignment for each files
  for (f in filesPath) {
    
    # make the word list
    wordList <- MakeWordList(f["input"])
    correct <- MakeWordList(f["correct"])
    
    # get the number of the regions
    regions <- length(wordList)
    
    # make output file path
    # outputPath <- "../Alignment/"
    # outputPath <- paste(outputPath, gsub("\\..+$", "", f["name"]), ".aln", sep = "")
    
    l <- 2
    count <- 0
    for (k in 1:(regions-1)) {
      # the start of the alignment for each the region pair
      for (i in l:regions) {
        correctMat <- RemkSeq(correct[[k]], correct[[i]])
        align <- NeedlemanWunsch(wordList[[k]], wordList[[i]], p1, p2, scoringMatrix)
        
        rltAln <- paste(paste(align$seq1, align$seq2, sep = ""), collapse = "")
        rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
        
        if (rltAln != rltCor) {
          sink(comparePath, append = T)
          cat("\n")
          print("by The Needleman-Wunsch")
          print(paste(align$seq1))
          print(align$seq2)
          
          cat("\n")
          print("by The Linguists")
          print(correctMat[1, ])
          print(correctMat[2, ])
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