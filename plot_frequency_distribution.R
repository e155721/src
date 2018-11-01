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