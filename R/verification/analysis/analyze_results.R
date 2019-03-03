.myfunc.env <- new.env()
source("verification/plot_functions.R")


# make the list for each file in all directories
dirPath <- "../Alignment/ex-11_26/gap/"
dirPath <- "../Alignment/ex-11_26/s5/"
dirPath <- "../Alignment/ex-11_29/gap/"
dirPath <- "../Alignment/ex-11/ex-11_29/gap/"
#dirPath <- "../Alignment/ex-12_03/gap_01-15/"
dirPath <- "../Alignment/ex-12_03/gap_01-10/"
dirPathList <- list.dirs(dirPath)
dirPathList <- dirPathList[-1]

filesList <- list()
i <- 1
for (d in dirPathList) {
  filesNameVec <- list.files(d)
  filesPathVec <- paste(d, filesNameVec, sep = "/")
  filesList[[i]] <- filesPathVec
  i <- i + 1
}

# make average list of correct answer rate
meanVec <- c()
minVec <- c()
diffVec <-c()
matchVec <- c()

meanVecList <- list()
minVecList <- list()
diffVecList <- list()
matchVecList <- list()

k <- 1
for (f in filesList) {
  i <- 1
  for (j in 1:length(f)) {
    # read data
    dataVec <- read.table(f[[j]])$V3
    # get the average for each the score pair
    meanVec[i] <- sum(dataVec)/length(dataVec)
    minVec[i] <- min(dataVec)
    diffVec[i] <- meanVec[i] - minVec[i]
    matchVec[i] <- sum(dataVec == 100)
    i <- i + 1
  }
  meanVecList[[k]] <- meanVec
  minVecList[[k]] <- minVec
  diffVecList[[k]] <- diffVec
  matchVecList[[k]] <- matchVec
  k <- k + 1
}

# select the vector the difference vector that has min elements
selectVec <- c()
min <- GetMinMax(diffVecList)["min"]
for (i in 1:length(diffVecList)) {
  if (min == min(diffVecList[[i]])) {
    print(i)
    selectVec <- append(selectVec, i, after = length(selectVec))
  }
}
filesList <- filesList[selectVec]
minVecList <- minVecList[selectVec]
meanVecList <- meanVecList[selectVec]
diffVecList <- diffVecList[selectVec]
matchVecList <- matchVecList[selectVec]

histList <- list()
i <- 1
for (diffVec in diffVecList) {
  print(filesList[[i]][which(diffVec == min)])
  histList[[i]] <- filesList[[i]][which(diffVec == min)]
  i <- i + 1
}

####### PLOT #######
# plot line graph
misTitle <- "Mismatch Score (s5) ="
misLab <- "Gap Penalty: p"

gapTitle <- "Gap Penalty (p) ="
gapLab <- "Mismatch Score: s5"

# fix values extract
dirPathList <- dirPathList[selectVec]
fixValVec <- as.numeric(gsub("^.*_", "", dirPathList))

if (0) {
  s <- 1
  xRange <- -1:-15
  yLim <- GetMinMax(meanVecList)
  switch(s,
         # plot the graphs of min matching rate for each gap penalty
         PlotGraph(xRange, meanVecList, fixValVec, yLim, gapTitle, gapLab),
         # plot the graphs of mean matching rate for each mismatch score
         PlotGraph(xRange, meanVecList, fixValVec, yLim, misTitle, misLab)
  )
}

if (0) {
  # plot histogram
  for (files in histList) {
    for (f in files) {
      PlotHist(f)
    }
  }
}
