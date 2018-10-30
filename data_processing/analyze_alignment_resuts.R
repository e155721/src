dirPath <- "../Alignment/results/wrong/wrong_align-15.txt"
filesName <- list.files(dirPath)
filesPath <- paste(dirPath, filesName, sep = "")

# make average list of correct answer rate
dataList <- c()
i <- 1
for (f in filesPath) {
  data <- read.table(f)$V2
  data <- sum(data)/length(data)
  dataList[[i]] <- data
  i <- i + 1
}

# make max average list of correct answer rate
maxAverage <- max(dataList)
maxAverageFiles <- list()
i <- 1
j <- 1
for (f in dataList) {
  if (f == maxAverage) {
    maxAverageFiles[[j]] <- filesPath[[i]]
    j <- j + 1
  }
  i <- i + 1
}

# make list of histogram object
h <- list()
i <- 1
for (f in maxAverageFiles) {
  data <- read.table(f)
  h[[i]] <- hist(data$V2, breaks = seq(0,100,10), main = f)
  i <- i + 1
}

##
scoreList <- list()
i <- 1
for (f in maxAverageFiles) {
  f <- gsub("wrong", "compare", f)
  f <- gsub("_align", "", f)
  f <- gsub("txt", "score", f)
  score <- read.table(f)$V1
  scoreList[[i]] <- score[1] - score[2]
  i <- i + 1
}