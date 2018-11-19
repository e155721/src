.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("data_processing/RemkSeq.R", envir = .myfunc.env)
sys.source("execute_alignment/MakeGapComb.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeScoringMatrix.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

# the preparing the data files
inputDir <- "../Alignment/input_data/"
inputFilese <- list.files(inputDir)
inputPaths <- paste(inputDir, inputFilese, sep = "")

correctDir <- "../Alignment/correct_data/"
correctFiles <- list.files(correctDir)
correctPaths <- paste(correctDir, correctFiles, sep = "")

filesPath <- list()
numOfFiles <- length(inputFilese)
for (i in 1:numOfFiles) {
  filesPath[[i]] <- c(NA, NA, NA)
  names(filesPath[[i]]) <- c("input", "correct", "name")
  filesPath[[i]]["input"] <- inputPaths[[i]]
  filesPath[[i]]["correct"] <- correctPaths[[i]]
  filesPath[[i]]["name"] <- inputFilese[[i]]
}




# constant penalty
numList <- makeGapComb(10, 1)
n <- 1
for (num in numList) {
  
  p1 <- num[[1]]
  p2 <- num[[1]]
  s5 <- num[[2]]
  
  # make scoring matrix
  scoringMatrix <- MakeFeatureMatrix(s5)
  
  ansratePath <- paste("../Alignment/ansrate-", n, ".txt", sep = "") 
  comparePath <- paste("../Alignment/compare-", n, ".txt", sep = "")
  
  # conduct the alignment for each files
  for (f in filesPath) {
    
    wordList <- MakeWordList(f["input"])
    regions <- length(wordList)
    correct <- MakeWordList(f["correct"])
    
    # make output file path
    # output file
    outputPath <- "../Alignment/"
    outputPath <- paste(outputPath, gsub("\\..+$", "", f["name"]), ".aln", sep = "")
    
    rltMat <- matrix(NA, regions, 2)
    rlt <- 1
    
    l <- 2
    count <- 0
    for (k in 1:(regions-1)) {
      # the start of the alignment for each the region pair
      for (i in l:regions) {
        correctMat <- RemkSeq(correct[[k]], correct[[i]])
        align <- NeedlemanWunsch(wordList[[k]], wordList[[i]], p1, p2, scoringMatrix)
        
        rltAln <- paste(paste(align$seq1, align$seq2, sep = ""), collapse = "")
        rltCor <- paste(paste(correctMat[1, ], correctMat[2, ], sep = ""), collapse = "")
        
        if (rltAln != rltCor) {
          sink(comparePath, append = T)
          cat("\n")
          print("by The Needleman-Wunsch")
          print(paste(align$seq1))
          print(align$seq2)
          
          cat("\n")
          print("by The Linguists")
          print(correctMat[1, ])
          print(correctMat[2, ])
          sink()
        } else {
          count <- count + 1
        }
        
        if (0) {
          sink(outputPath, append = T)
          cat("\n")
          print("by The Needleman-Wunsch")
          print(paste(align$seq1))
          print(align$seq2)
          sink()
        }
      }
      # the end of the aligne for each the region pair
      l <- l + 1
    }
    
    if (0) {
      sink(ansratePath, append = T)
      matchingRate <- count / sum((regions-1):1) * 100
      rlt <- paste(f["name"], matchingRate, sep = " ")
      print(rlt)
      sink()
      print(rlt)
    }
    
    

    if (1) {
      matchingRate <- count / sum((regions-1):1) * 100
      rltMat[rlt, ] <- as.vector(paste(f["name"], matchingRate, sep = " "))
      rlt <- rlt + 1
    }
  }
  
  write(rltMat, ansratePath)
  

  
  
  n <- n + 1
  
  
}
