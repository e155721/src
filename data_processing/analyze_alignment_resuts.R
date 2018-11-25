.myfunc.env <- new.env()
sys.source("execute_alignment/MakeGapComb.R", envir = .myfunc.env)
attach(.myfunc.env)

#dirPath <- "../Alignment/ex-10_30/analyze/"
dirPath <- "../Alignment/ex-11_19/ansrate/"
dirPath <- "../Alignment/ex-11_19-second/ansrate/"
filesName <- list.files(dirPath)
filesPath <- paste(dirPath, filesName, sep = "")

# make average list of correct answer rate
meanVec <- c()
matchVec <- c()
i <- 1
for (f in filesPath) {
  # read data
  data <- read.table(f)$V3
  # get the matching words
  matchVec <- append(matchVec, sum(data == 100), after = length(matchVec))
  # get the average for each the score pair
  data <- sum(data)/length(data)
  meanVec[i] <- data
  i <- i + 1
}
# get the max matching word
maxMatch <- max(matchVec)
# get the max matching word files
maxMatchVec <- filesPath[which(matchVec==maxMatch)]

# make max average list of correct answer rate
maxAverage <- max(meanVec)
maxAverageFiles <- list()
scoreVec <- c()
i <- 1
j <- 1
for (f in meanVec) {
  if (f == maxAverage) {
    scoreVec <- append(scoreVec, i, after = length(scoreVec))
    maxAverageFiles[[j]] <- filesPath[[i]]
    j <- j + 1
  }
  i <- i + 1
}

# make list of histogram object
h <- list()
i <- 1
for (f in maxAverageFiles) {
  data <- read.table(f)$V3
  h[[i]] <- hist(data, breaks = seq(0,100,10), main = "",
                 right = F,
                 labels = T, 
                 xaxt = "n",
                 ylim = c(0,111),
                 xlab = "Matching Rate (%)",
                 ylab = "Words Frequency",
                 bg = "transparent")
  axis(1, at=seq(0,100,10), pos=-3)
  abline(v=mean(data), col=2, lwd=3, lty=2)
  text(x = mean(data)-20, y = 110, paste("Matching Rate Average =", round(maxAverage, digits = 3), "%", sep = " "), col = 2)
  # legend("topleft","Matching Rate Average", col=2, lwd=3, lty = 2)
  i <- i + 1
}

plot(meanVec, type = "l", xlab = "Score Pair", ylab = "Matching Rate Average (%)")
abline(h=maxAverage, col=2, lwd=3, lty=2)
#legend(locator(1), legend="Matching Rate Average = 96.909 %", col=2, lwd=3, lty=2, bty = "n")
legend(locator(1), legend=paste("Matching Rate Average =", round(maxAverage, digits = 3), "%", sep = " "), col=2, lwd=3, lty=2, bty = "n")
#legend("bottomleft", "Matching Rate Average = 96.909 %", col=2, lwd=3, lty = 2,
#bty = "n")

print(paste("Max Average:", maxAverage, sep = " "))
print(paste("Max Matching Rate:", (maxMatch/111)*100, sep = " "))
print(paste("Max Matching Words:", maxMatch, sep = " "))

scorePair <- makeGapComb(10,1)
print(paste(scorePair[scoreVec]))
print(paste(maxAverageFiles, maxMatchVec, sep = " "))
