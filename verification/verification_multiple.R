.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p1 <- p2 <- -3

inFilesList <- list.files("../Alignment/input_data/")
corFilesList <- list.files("../Alignment/correct_data/")

inFilesList <- paste("../Alignment/input_data/", inFilesList, sep = "")
corFilesList <- paste("../Alignment/correct_data//", corFilesList, sep = "")

cor <- 1
# for (cor in filesList) {
for (f in inFilesList) {
  wordList <- MakeWordList(f)
  correctWordList <- MakeWordList(corFilesList[[cor]])
  correctWordList$list <- rev(correctWordList$list)
  
  lenWordList <- length(wordList$list)
  wordList$list <- rev(wordList$list)
  i <- 1
  align <- NeedlemanWunsch(wordList$list[[i]], wordList$list[[i+1]], p1, p2, scoringMatrix)
  i <- i + 2
  while (i <= lenWordList) {
    align <- NeedlemanWunsch(align$multi, wordList$list[[i]], p1, p2, scoringMatrix)
    i <- i + 1
  }
  
  # correct
  nrow <- length(correctWordList$list)
  ncol <- length(correctWordList$list[[1]])
  
  correctMat <- matrix(NA, nrow, ncol)
  for (i in 1:nrow) {
    correctMat[i, ] <- correctWordList$list[[i]]
  }
  
  j <- 1
  while (j <= dim(correctMat)[2]) {
    m <- match(correctMat[, j], "-")
    m <- !is.na(m)
    if (sum(m) == nrow) {
      correctMat <- correctMat[, -j]
    }
    j <- j + 1
  }
  
  # check
  count <- 0
  for (i in 1:nrow) {
    if (paste(correctMat[i, ], collapse = "") == paste(align$multi[i, ], collapse = "")) {
      count <- count + 1
    }
  }
  match <- (count/nrow)*100
  print((count/nrow)*100)
  
  sink("multi_test.txt", append = T)
  print(paste(f, match, sep = " "), quote = F)
  sink()
  
  cor <- cor + 1
}
