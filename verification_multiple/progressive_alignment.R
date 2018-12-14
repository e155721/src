.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

wordList <- MakeWordList("../Alignment/input_data/002.dat")

file <- "../Alignment/input_data/129.dat"
wordList <- MakeWordList(file)
lenWordList <- length(wordList$list)
distMat <- matrix(NA, lenWordList, lenWordList)

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

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

distMat <- distMat[-dim(distMat), ]
aln.d <- dist(distMat)
aln.hc <- hclust(aln.d)

mat <- aln.hc$merge
len <- dim(mat)[1]

# check the guide tree
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
