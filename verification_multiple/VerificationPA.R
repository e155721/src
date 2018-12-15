.myfunc.env = new.env()
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
attach(.myfunc.env)

VerificationPA <- function(inFile, corFile, p, scoringMatrix)
{
  wordList <- MakeWordList(inFile)
  paRlt <- ProgressiveAlignment(wordList, p, scoringMatrix)
  inputAlign <- paRlt$multi
  mat <- paRlt$guide
  
  # make correct matrix
  corWordList <- MakeWordList(corFile)
  lenCorWordList <- length(corWordList$list)
  
  nrow <- length(corWordList$list)
  ncol <- length(corWordList$list[[1]])
  
  corMat <- c()
  for (i in 1:nrow) {
    corMat <- rbind(corMat, corWordList$list[[i]])
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
  
  len <- dim(mat)[1]
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
  corAlign <- tail(corGuide, n = 1)[[1]]
  count <- 0
  for (i in 1:lenCorWordList) {
    input <- paste(inputAlign[i, ], collapse = "")
    correct <- paste(corAlign[i, ], collapse = "")
    if (input == correct) {
      count <- count + 1
    }
  }
  
  matchingRate <- (count/nrow)*100
  return(matchingRate)
}
