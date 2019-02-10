source("data_processing/MakeWordList.R")
source("data_processing/RemkSeq.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("verification/GetFilesPath.R")
source("verification/ForEachRegion.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                          correctDir = "../Alignment/correct_data/")

gapVec <- -1:-15
misVec <- -1:-15
digits <- 2

lenGapVec <- length(gapVec)
lenMisVec <- length(misVec)

# for (p in gapVec) {
pairwise <- foreach (p = gapVec) %dopar% {
  
  output_path <- "../Alignment/gap_"
  output_compPath <- "../Alignment/comparison_"
  
  output_path <- paste(output_path, formatC(-p, width = digits, flag = 0), "/", sep = "")
  print(output_path)
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  output_compPath <- paste(output_compPath, formatC(-p, width = digits, flag = 0), "/", sep = "")
  print(output_compPath)
  if (!dir.exists(output_compPath)) {
    dir.create(output_compPath)
  }
  
  # constant penalty
  for (mis in misVec) {
    s5 <- mis
    
    # make scoring matrix
    scoringMatrix <- MakeFeatureMatrix(s5, p)
    
    # make the output paths
    ansratePath <- paste(output_path, "ansrate-", 
                         formatC(-mis, width = digits, flag = 0), ".txt", sep = "") 
    # comparePath <- paste(output_path, "compare-", 
    #                     formatC(-mis, width = digits, flag = 0), ".txt", sep = "")
    
    # conduct the alignment for each files
    for (f in filesPath) {
      # display the progress
      # print(paste("Whole Progress:", (p/tail(gapVec, n = 1))*100, sep = " "))
      # print(paste("Progress:", (mis/tail(misVec, n = 1))*100, sep = " "))
      
      comparePath <- paste(output_compPath, "compare-", 
                           gsub("\\..*$", "", f["name"]), ".txt", sep = "")
      
      # make the word list
      wordList <- MakeWordList(f["input"])
      correct <- MakeWordList(f["correct"])
      
      print(paste("input:", f["input"], sep = " "))
      print(paste("correct:", f["correct"], sep = " "))
      cat("\n")
      
      # get the number of the regions
      regions <- length(wordList)
      corRegions <- length(correct)
      
      # conduct the alignment for each region
      # ForEachRegion(correct, wordList, -p, scoringMatrix,
      ForEachRegion(f, correct, wordList, p, scoringMatrix,
                    ansratePath, comparePath, regions, comparison = T)
    }
  }
}
