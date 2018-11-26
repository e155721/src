.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("data_processing/RemkSeq.R", envir = .myfunc.env)
sys.source("execute_alignment/MakeGapComb.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("verification/GetFilesPath.R", envir = .myfunc.env)
sys.source("verification/ForEachRegion.R", envir = .myfunc.env)
attach(.myfunc.env)

# get the all of files path
filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                          correctDir = "../Alignment/correct_data/")

gapVec <- 11:15
numVec <- 11:15
# gapVec <- 1:10
# numVec <- 1:10

lenGapVec <- length(gapVec)
lenNumVec <- length(numVec)

for (p in gapVec) {
  
  output_path <- "../Alignment/gap_"
  output_path <- paste(output_path, p, "/", sep = "")
  print(output_path)
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  # constant penalty
  # numList <- MakeGapComb(10, 1)
  # n <- 1
  for (num in numVec) {
    p1 <- -p
    p2 <- -p
    s5 <- -num
    
    # make scoring matrix
    scoringMatrix <- MakeFeatureMatrix(s5)
    
    # make the output paths
    ansratePath <- paste(output_path, "ansrate-", num, ".txt", sep = "") 
    comparePath <- paste(output_path, "compare-", num, ".txt", sep = "")
    
    # conduct the alignment for each files
    for (f in filesPath) {
      # display the progress
      print(paste("Whole Progress:", (p/lenGapVec)*100, sep = " "))
      print(paste("Progress:", (num/lenNumVec)*100, sep = " "))
      
      # make the word list
      wordList <- MakeWordList(f["input"])
      correct <- MakeWordList(f["correct"])
      
      print(paste("input:", f["input"], sep = " "))
      print(paste("correct:", f["correct"], sep = " "))
      cat("\n")
      
      # get the number of the regions
      regions <- length(wordList$vec)
      corRegions <- length(correct$vec)
      # check the error    
      if (regions != corRegions) {
        print("HOGE!!!")
        print(f["input"])
        return(1)
      }
      
      # conduct the alignment for each region
      ForEachRegion(correct, wordList, ansratePath, comparePath, regions)
    }
  }
}
