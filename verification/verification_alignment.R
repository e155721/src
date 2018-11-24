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
                          correctDir = "../Alignment/org_data/")

# constant penalty
# numList <- makeGapComb(10, 1)
numList <- makeGapComb(1, 1)
n <- 1

for (num in numList) {
  #p1 <- num[[1]]
  #p2 <- num[[1]]
  p1 <- p2 <- -1
  s5 <- -2
  
  # make scoring matrix
  scoringMatrix <- MakeFeatureMatrix(s5)
  
  # make the output paths
  ansratePath <- paste("../Alignment/ansrate-", n, ".txt", sep = "") 
  comparePath <- paste("../Alignment/compare-", n, ".txt", sep = "")
  
  # conduct the alignment for each region
  ForEachRegion(filesPath, ansratePath, comparePath)
  
  # display the progress
  print(paste("Progress:", (n/length(numList))*100, sep = " "))
  n <- n + 1
}
