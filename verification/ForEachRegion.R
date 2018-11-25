ForEachRegion <- function(correct, wordList, ansratePath, comparePath, comparison = F)
{
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
        if (comparison) {
          sink(comparePath, append = T)
          cat("\n")
          print("by The Needleman-Wunsch")
          rltVec1 <- rltVec2 <- c()
          rltVec1[1] <- wordList$vec[k]
          rltVec1[2] <- paste(align$seq1, collapse = " ")
          rltVec2[1] <- wordList$vec[i]
          rltVec2[2] <- paste(align$seq2, collapse = " ")
          print(rltVec1)
          print(rltVec2)
          
          cat("\n")
          print("by The Linguists")
          rltVec1 <- rltVec2 <- c()
          rltVec1[1] <- correct$vec[k]
          rltVec1[2] <- paste(correctMat[1, ], collapse = " ")
          rltVec2[1] <- correct$vec[i]
          rltVec2[2] <- paste(correctMat[2, ], collapse = " ")
          print(rltVec1)
          print(rltVec2)
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
  matchingRate <- count / sum((regions-1):1) * 100
  rlt <- paste(f["name"], matchingRate, sep = " ")
  print(rlt, quote = F)
  sink()
  
  return(0)
}