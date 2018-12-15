.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

ProgressiveAlignment <- function(inFile, corFile)
{
  wordList <- MakeWordList(inFile)
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
  
  aln.d <- dist(distMat)
  aln.hc <- hclust(aln.d)
  
  mat <- aln.hc$merge
  len <- dim(mat)[1]
  
  # progressive alignment
  guide <- list()
  for (i in 1:len) {
    flg <- sum(mat[i, ] < 0)
    if (flg == 2) {
      seq1 <- mat[i, 1] * -1
      seq2 <- mat[i, 2] * -1
      aln <- NeedlemanWunsch(wordList$list[[seq1]], wordList$list[[seq2]], p, p, scoringMatrix)
      guide[[i]] <- aln$multi
    } 
    else if(flg == 1) {
      clt <- mat[i, 2]
      seq2 <- mat[i, 1] * -1
      aln <- NeedlemanWunsch(guide[[clt]], wordList$list[[seq2]], p, p, scoringMatrix)
      guide[[i]] <- aln$multi
    } else {
      clt1 <- mat[i, 1]
      clt2 <- mat[i, 2]
      aln <- NeedlemanWunsch(guide[[clt1]], guide[[clt2]], p, p, scoringMatrix)
      guide[[i]] <- aln$multi
    }
  }
  
  # make correct matrix
  corWordList <- MakeWordList(corFile)
  lenCorWordList <- length(corWordList$list)
  
  nrow <- length(corWordList$list)
  ncol <- length(corWordList$list[[1]])
  
  corMat <- matrix(NA, nrow, ncol)
  for (i in 1:nrow) {
    corMat[i, ] <- corWordList$list[[i]]
  }
  
  j <- 1
  while (j <= dim(corMat)[2]) {
    m <- match(corMat[, j], "-")
    m <- !is.na(m)
    if (sum(m) == nrow) {
      corMat <- corMat[, -j]
    }
    j <- j + 1
  }
  
  corGuide <- list()
  for (i in 1:len) {
    flg <- sum(mat[i, ] < 0)
    if (flg == 2) {
      seq1 <- mat[i, 1] * -1
      seq2 <- mat[i, 2] * -1
      aln <- rbind(corMat[seq1, ], corMat[seq2, ])
      corGuide[[i]] <- aln
    } 
    else if(flg == 1) {
      clt <- mat[i, 2]
      seq2 <- mat[i, 1] * -1
      aln <- rbind(corGuide[[clt]], corMat[seq2, ])
      corGuide[[i]] <- aln
    } else {
      clt1 <- mat[i, 1]
      clt2 <- mat[i, 2]
      aln <- rbind(corGuide[[clt1]], corGuide[[clt2]])
      corGuide[[i]] <- aln
    }
  }
  
  # calculate matching rate
  inputAlign <- tail(guide, n = 1)[[1]]
  corAlign <- tail(corGuide, n = 1)[[1]]
  
  count <- 0
  for (i in 1:lenWordList) {
    input <- paste(inputAlign[i, ], collapse = "")
    correct <- paste(corAlign[i, ], collapse = "")
    if (input == correct) {
      count <- count + 1
    }
  }
  
  match <- (count/nrow)*100
  print((count/nrow)*100)
  
  matchingRate <- (count / lenWordList) * 100
  return(matchingRate)
}
