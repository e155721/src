ForEachRegion <- function(correct, wordList, p, scoringMatrix,
                          ansratePath, comparePath, regions, comparison = F)
{
  l <- 2
  count <- 0
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (i in l:regions) {
      correctMat <- RemkSeq(correct[[k]], correct[[i]])
      align <- NeedlemanWunsch(as.matrix(wordList[[k]], drop = F), 
                               as.matrix(wordList[[i]], drop = F), p, p, scoringMatrix)
      rltAln <- paste(paste(align$seq1, align$seq2, sep = ""), collapse = "")
      rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
      
      if (rltAln != rltCor) {
        if (comparison) {
          sink(comparePath, append = T)
          # by The Linguists
          cat("\n")
          print(c(correct[[k]],
                  paste(correctMat[1, ], collapse = " ")))
          print(c(correct[[i]],
                  paste(correctMat[2, ], collapse = " ")))
          
          # by The Needleman-Wunsch
          cat("\n")
          print(c(wordList[[k]], 
                  paste(align$seq1, collapse = " ")))
          print(c(wordList[[i]],
                  paste(align$seq2, collapse = " ")))
          sink()
        }
      } else {
        count <- count + 1
      }
    }
    # the end of the aligne for each the region pair
    l <- l + 1
  }
  
  # output the matching rate
  sink(ansratePath, append = T)
  allResions <- sum((regions-1):1)
  matchingRate <- count / allResions * 100
  misMatchRate <- (allResions - count) / allResions * 100
  rlt <- paste(f["name"], matchingRate, misMatchRate, sep = " ")
  print(rlt, quote = F)
  sink()
  
  return(0)
}
