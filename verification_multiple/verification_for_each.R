
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")
source("verification/GetFilesPath.R")
source("verification_multiple/ProgressiveAlignment.R")
source("verification_multiple/VerificationPA.R")


scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

# get the all of files path
filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                          correctDir = "../Alignment/correct_data/")

for (f in filesPath) {
  wordList <- MakeWordList(f[["input"]])
  lenWordList <- length(wordList$list)
  distMat <- matrix(NA, lenWordList, lenWordList)
  
  matchingRate <- ProgressiveAlignment(f[["input"]], f[["correct"]])
  print(matchingRate)
  
  sink("multi_test.txt", append = T)
  print(paste(f[["name"]], matchingRate, sep = " "), quote = F)
  sink()
}
