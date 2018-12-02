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
  comparePath <- paste("../Alignment/compare-", w, ".txt", sep = "")
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
