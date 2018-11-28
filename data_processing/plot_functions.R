# histogram plot function
PlotHist <- function(inFile)
{
  # read data file
  data <- read.table(inFile)$V3
  dataLen <- length(data)
  
  # make output file name
  outPath <- gsub(basename(inFile), "", inFile)
  outFile <- paste(outPath, gsub("\\..*$", ".pdf", basename(f)), sep = "")
  
  pdf(outFile)
  hist(data, breaks = seq(0,100,10), main = "",
       right = F,
       labels = T, 
       xaxt = "n",
       ylim = c(0, dataLen),
       xlab = "Matching Rate (%)",
       ylab = "Word Frequency")
  axis(1, at=seq(0,100,10), pos=-3)
  abline(v=mean(data), col=2, lwd=3, lty=2)
  text(x = mean(data)-25, y = 110, 
       paste("Matching Rate Average =", round(maxAverage, digits = 3), "%", sep = " "), col = 2)
  dev.off()
}
