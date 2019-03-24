source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")

ProgressiveAlignment <- function(wordList, s)
{
  lenWordList <- length(wordList)
  distMat <- matrix(NA, lenWordList, lenWordList)
  
  for (j in 1:(lenWordList-1)) {
    # the start of the alignment for each the region pair
    for (i in 1:lenWordList) {
      align <- NeedlemanWunsch(wordList[[i]], wordList[[j]], s)
      distMat[i, j] <- align$score
    }
  }
  
  # make guide tree  
  aln.d <- dist(distMat)
  aln.hc <- hclust(aln.d, "average")
  gtree <- aln.hc$merge
  
  # progressive alignment
  progressive <- list()
  len <- dim(gtree)[1]
  for (i in 1:len) {
    flg <- sum(gtree[i, ] < 0)
    if (flg == 2) {
      seq1 <- gtree[i, 1] * -1
      seq2 <- gtree[i, 2] * -1
      aln <- NeedlemanWunsch(wordList[[seq1]], wordList[[seq2]], s)
      progressive[[i]] <- DelGap(aln$multi)
    } 
    else if(flg == 1) {
      clt <- gtree[i, 2]
      seq2 <- gtree[i, 1] * -1
      aln <- NeedlemanWunsch(progressive[[clt]], wordList[[seq2]], s)
      progressive[[i]] <- DelGap(aln$multi)
    } else {
      clt1 <- gtree[i, 1]
      clt2 <- gtree[i, 2]
      aln <- NeedlemanWunsch(progressive[[clt1]], progressive[[clt2]], s)
      progressive[[i]] <- DelGap(aln$multi)
    }
  }
  
  # return
  paRlt <- list(NA, NA)
  names(paRlt) <- c("multi", "gtree")
  paRlt$multi <- tail(progressive, n = 1)[[1]]
  paRlt$gtree <- gtree
  paRlt$score <- aln$score
  return(paRlt)
}
