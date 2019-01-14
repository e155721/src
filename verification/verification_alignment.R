.myfunc.env <- new.env()
source("data_processing/MakeWordList.R")
source("data_processing/RemkSeq.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("verification/GetFilesPath.R")
source("verification/ForEachRegion.R")


# get the all of files path
filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                          correctDir = "../Alignment/correct_data/")

p <- -3
s5 <- -10

# make scoring matrix
scoringMatrix <- MakeFeatureMatrix(s5)

# make the output paths
ansratePath <- paste("../Alignment/ansrate.txt", sep = "") 

w <- 1
# conduct the alignment for each files
for (f in filesPath) {
  # make compare path
  n <- gsub("\\..*$", "", basename(f["input"]))
  comparePath <- paste("../Alignment/compare-", n, ".txt", sep = "")
  # comparePath <- paste("../Alignment/compare-", w, ".txt", sep = "")
  w <- w + 1
  
  # make the word list
  wordList <- MakeWordList(f["input"])
  correct <- MakeWordList(f["correct"])
  
  # get the number of the regions
  regions <- length(wordList$vec)
  
  # conduct the alignment for each region
  ForEachRegion(correct, wordList, p, scoringMatrix,
                ansratePath, comparePath, regions, comparison = T)
  
  # display the progress
  print(paste("Progress:", ((w-1)/length(filesPath))*100, sep = " "))
}
