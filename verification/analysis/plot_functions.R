####################
# get values max and min in minVecList
GetMinMax <- function(list)
{
  x <- c()
  for (i in list) {
    x <- append(x, i, length(x))
  }
  rltVec <- c()
  rltVec["min"] <- min(x)
  rltVec["max"] <- max(x)
  
  return(rltVec)
}

PlotGraph <- function(x, list, fixValVec, yLim, title, xlab)
{
  for (i in 1:length(list)) {
    plot(x = x, y = list[[i]], type = "l",
         ylim = c(yLim["min"], yLim["max"]),
         main = paste(title, -fixValVec[i], sep = " "),
         xlab = xlab, ylab = "Matching Rate (%)")
  }
}

# histogram plot function
PlotHist <- function(inFile)
{
  # read data file
  data <- read.table(inFile)$V3
  mean <- mean(data)
  dataLen <- length(data)
  
  hist(data, breaks = seq(0,100,10), main = inFile,
       right = F,
       labels = T, 
       xaxt = "n",
       ylim = c(0, dataLen),
       xlab = "Matching Rate (%)",
       ylab = "Word Frequency")
  axis(1, at=seq(0,100,10), pos=-3)
  abline(v=mean, col=2, lwd=3, lty=2)
  text(x = mean(data)-25, y = 110, 
       paste("Average Matching Rate =", round(mean, digits = 3), "%", sep = " "), col = 2)
}
