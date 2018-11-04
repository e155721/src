PlotFrequencyDistribution <- function(dirPath = "../Alignment/ex-10_30/ansrate/ansrate-15.txt")
{
  filesName <- list.files(dirPath)
  filesPath <- paste(dirPath, filesName, sep = "")
  
  # make list of histogram object
  h <- list()
  i <- 1
  for (f in filesPath) {
    data <- read.table(f)
    h[[i]] <- hist(data$V3, breaks = seq(0,100,10), main = f)
    i <- i + 1
  }
}


dirPath = "../Alignment/ex-10_30/ansrate/ansrate-15.txt"
filesName <- list.files(dirPath)
filesPath <- paste(dirPath, filesName, sep = "")

# make list of histogram object
h <- list()
i <- 1
for (f in filesPath) {
  data <- read.table(f)
  h[[i]] <- hist(data$V3, breaks = seq(0,100,10), xlab = "Accuracy Rate", main = "", right = F)
  i <- i + 1
}


dirPath <- list.dirs("../Alignment/ex-10_30/val/words_unique/")
filesName <- list.files("../Alignment/ex-10_30/val/words_unique/")
filesPath <- paste(dirPath, filesName, sep = "")

for (f in filesPath) {
  h <- read.table(f)
  dh <- dim(h)
  mat <- matrix(NA, nrow = dh[1], ncol = dh[2])
  for (i in 1:dh[2]) {
    mat[, i] <- as.vector(h[[i]])
  }
  
  write.table(unique(mat), f)
}


dirPath <- list.dirs("../Alignment/ex-10_30/val/words_unique/")
filesName <- list.files("../Alignment/ex-10_30/val/words_unique/")
filesPath <- paste(dirPath, filesName, sep = "")

table <- list()
i <- 1
for (f in filesPath) {
  w <- read.table(f)
  table[[i]] <- xtable(w)
  i <- i + 1
}

