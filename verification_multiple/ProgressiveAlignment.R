.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

ProgressiveAlignment <- function(wordList, p, scoringMatrix)
{
  lenWordList <- length(wordList$list)
  distMat <- matrix(NA, lenWordList, lenWordList)
  
  i <- 2
  for (j in 1:(lenWordList-1)) {
    # the start of the alignment for each the region pair
    for (i in 1:lenWordList) {
      align <- NeedlemanWunsch(wordList$list[[i]], wordList$list[[j]], p, p, scoringMatrix)
      distMat[i, j] <- align$score
    }
    # the end of the aligne for each the region pair
    i <- i + 1
  }
  
  # make guide tree  
  aln.d <- dist(distMat)
  aln.hc <- hclust(aln.d)
  guide <- aln.hc$merge
  
  # progressive alignment
  progressive <- list()
  len <- dim(guide)[1]
  for (i in 1:len) {
    flg <- sum(guide[i, ] < 0)
    if (flg == 2) {
      seq1 <- guide[i, 1] * -1
      seq2 <- guide[i, 2] * -1
      aln <- NeedlemanWunsch(wordList$list[[seq1]], wordList$list[[seq2]], p, p, scoringMatrix)
      progressive[[i]] <- aln$multi
    } 
    else if(flg == 1) {
      clt <- guide[i, 2]
      seq2 <- guide[i, 1] * -1
      aln <- NeedlemanWunsch(progressive[[clt]], wordList$list[[seq2]], p, p, scoringMatrix)
      progressive[[i]] <- aln$multi
    } else {
      clt1 <- guide[i, 1]
      clt2 <- guide[i, 2]
      aln <- NeedlemanWunsch(progressive[[clt1]], progressive[[clt2]], p, p, scoringMatrix)
      progressive[[i]] <- aln$multi
    }
  }
  
  # return
  paRlt <- list(NA, NA)
  names(paRlt) <- c("multi", "guide")
  paRlt$multi <- tail(progressive, n = 1)[[1]]
  paRlt$guide <- guide
  paRlt$score <- aln$score
  return(paRlt)
}
