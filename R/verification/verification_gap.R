source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("verification/ForEachRegion.R")
source("needleman_wunsch/MakeFeatureMatrix.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

pVec <- -1:-15
s5Vec <- -1:-15
digits <- 2

lenpVec <- length(pVec)
lens5Vec <- length(s5Vec)

# for (p in pVec) {
pairwise <- foreach (p = pVec) %dopar% {
  
  output_path <- "../../Alignment/gap_"
  comparePath <- "../../Alignment/comparison_"
  
  output_path <- paste(output_path, formatC(-p, width = digits, flag = 0), "/", sep = "")
  print(output_path)
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  # result path
  comparePath <- paste(comparePath, formatC(-p, width = digits, flag = 0), "/", sep = "")
  print(comparePath)
  if (!dir.exists(comparePath)) {
    dir.create(comparePath)
  }
  
  # constant penalty
  for (s5 in s5Vec) {
    
    # matchingrate path
    ansratePath <- paste(output_path, "ansrate-", 
                         formatC(-s5, width = digits, flag = 0), ".txt", sep = "") 
    
    # result path
    comparePath <- paste(comparePath, "s5_", formatC(-s5, width = digits, flag = 0), "/", sep = "")
    print(comparePath)
    if (!dir.exists(comparePath)) {
      dir.create(comparePath)
    }
    
    # conduct the alignment for each files
    for (f in filesPath) {
      
      # make the word list
      wordList <- MakeWordList(f["input"])
      correct <- MakeWordList(f["correct"])
      
      print(paste("input:", f["input"], sep = " "))
      print(paste("correct:", f["correct"], sep = " "))
      cat("\n")
      
      # get the number of the regions
      regions <- length(wordList)
      corRegions <- length(correct)
      
      # make scoring matrix
      scoringMatrix <- MakeFeatureMatrix(s5, p)
      
      # conduct the alignment for each region
      ForEachRegion(f, correct, wordList, scoringMatrix,
                    ansratePath, comparePath, regions, comparison = T)
    }
  }
}
