.myfunc.env <- new.env()
sys.source("execute_alignment/MakeGapComb.R", envir = .myfunc.env)
attach(.myfunc.env)

#dirPath <- "../Alignment/s5_10/"
dirPath <- "../Alignment/gap_1/"
filesName <- list.files(dirPath)
filesPath <- paste(dirPath, filesName, sep = "")

valVec <- filesPath
valVec <- gsub("^.*-", "", valVec)
valVec <- gsub("\\..*$", "", valVec)

tmp <- matrix(NA, length(valVec), 2)
tmp[, 1] <- as.numeric(valVec)
tmp[, 2] <- filesPath
tmp <- tmp[order(as.numeric(tmp[, 1])), ]
filesPath <- tmp[, 2]

# make average list of correct answer rate
meanVec <- c()
minVec <- c()
diffVec <-c()
matchVec <- c()
i <- 1
for (f in filesPath) {
  # read data
  dataVec <- read.table(f)$V3
  # get the matching words
  matchVec <- append(matchVec, sum(dataVec == 100), after = length(matchVec))
  # get the average for each the score pair
  mean <- sum(dataVec)/length(dataVec)
  meanVec[i] <- mean
  minVec[i] <- min(dataVec)
  diffVec[i] <- meanVec[i] - minVec[i]
  i <- i + 1
}
# get the max matching word
maxMatch <- max(matchVec)
# get the max matching word files
maxMatchVec <- filesPath[which(matchVec==maxMatch)]

# make max average list of correct answer rate
if (0) {
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
}

average <- sum(meanVec)/length(meanVec)
# plot(meanVec, type = "l", xlab = "Gap Penalty", ylab = "Matching Rate Average (%)")
# plot(x = -1:-10, y = meanVec, type = "l", xlab = "Gap Penalty", ylab = "Matching Rate Average (%)")
plot(x = -1:-10, y = meanVec, type = "l", 
     xlab = "Mismatch Score (s5)", ylab = "Matching Rate Average (%)",
     xlim = c(-1,-10), ylim = c(95,97))
par(new = T)
#par(new = T)
#plot(x = -1:-10, y = diffVec, type = "l", xaxt = "n", yaxt = "n", ann = F)
#abline(h=average, col=2, lwd=3, lty=2)
#legend(locator(1), legend=paste("Matching Rate Average =", round(maxAverage, digits = 3), "%", sep = " "), col=2, lwd=3, lty=2, bty = "n")
