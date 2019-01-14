PlotFrequencyDistribution <- function(dirPath = "../Alignment/ex-10_30/ansrate/ansrate-21.txt")
{
  filesName <- list.files(dirPath)
  filesPath <- paste(dirPath, filesName, sep = "")
  
  # make list of histogram object
  h <- list()
  i <- 1
  for (f in filesPath) {
    data <- read.table(f)
    h[[i]] <- hist(data$V3, breaks = seq(0,100,10), main = "",
                   right = F,
                   labels = T, 
                   xaxt = "n",
                   ylim = c(0,127),
                   xlab = "Matching Rate (%)",
                   ylab = "Words Frequency",
                   bg = "transparent")
    axis(1, at=seq(0,100,10), pos=-3)
    abline(v=mean(data$V3), col=2, lwd=3, lty = 2)
    #text(x = mean(data$V3)-10, y = 100, "mean = (85%)", col = 2)
    #text(x = mean(data$V3)-10, y = 100, "Matching Rate Average\n(85%)", col = 2)
    i <- i + 1
  }
}
PlotFrequencyDistribution()

#z = locator(1)
#legend(z$x, z$y, "Matching Rate Average", col=2, lwd=3, lty = 2, bty = "n")
legend("topleft","Matching Rate Average",col=2, lwd=3, lty = 2)

tmp <- data$V2
for (i in 1:127) {
  if(40 <= tmp[i] && tmp[i] <= 50)
    print(tmp[i])
}












if (0) {
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
  
  file <- "../Alignment/ex-10_30/val/tm"
  data <- read.table(file)
  
  names <- as.vector(1:127)
  rate <- sort(as.vector(data$V2))
  
  h <- hist(data)
  
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
}
