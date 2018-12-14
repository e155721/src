.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

inFilesList <- list.files("../Alignment/input_data/")
corFilesList <- list.files("../Alignment/correct_data/")

inFilesList <- paste("../Alignment/input_data/", inFilesList, sep = "")
corFilesList <- paste("../Alignment/correct_data/", corFilesList, sep = "")

cor <- 1
for (f in inFilesList) {
  scoringMatrix <- MakeFeatureMatrix(-10, -3)
  p <- -3
  
  wordList <- MakeWordList(f)
  lenWordList <- length(wordList$list)
  distMat <- matrix(NA, lenWordList, lenWordList)
  
  l <- 2
  for (k in 1:(lenWordList-1)) {
    # the start of the alignment for each the region pair
    for (l in 1:lenWordList) {
      align <- NeedlemanWunsch(wordList$list[[k]], wordList$list[[l]], p, p, scoringMatrix)
      distMat[k, l] <- align$score
    }
    # the end of the aligne for each the region pair
    l <- l + 1
  }
  
  distMat <- t(distMat)
  distMat <- distMat[, -dim(distMat)[2]]
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
  corFile <- corFilesList[[cor]]
  cor <- cor + 1
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
  
  sink("multi_test.txt", append = T)
  print(paste(f, match, sep = " "), quote = F)
  sink()
}
