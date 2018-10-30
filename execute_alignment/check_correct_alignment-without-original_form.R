.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("execute_alignment/ExecutePairWise.R", envir = .myfunc.env)
sys.source("execute_alignment/MakeGapComb.R", envir = .myfunc.env)
attach(.myfunc.env)

inputDirPath <- "../Alignment/input_data/"
inputFilesName <- list.files(inputDirPath)
inputFilesPath <- paste(inputDirPath, inputFilesName, sep = "")

correctDirPath <- "../Alignment/correct_data/"
correctFilesName <- list.files(correctDirPath)
correctFilesPath <- paste(correctDirPath, correctFilesName, sep = "")

filesPath <- list()
numOfFiles <- length(inputFilesName)
for (i in 1:numOfFiles) {
  filesPath[[i]] <- c(NA, NA, NA)
  names(filesPath[[i]]) <- c("input", "correct", "inName")
  filesPath[[i]][1] <- inputFilesPath[[i]]
  filesPath[[i]][2] <- correctFilesPath[[i]]
  filesPath[[i]][3] <- inputFilesName[[i]]
}

# define a score and gap penaltys
#s5 <- -2
#p1 <- -5
#p2 <- -5

# constant penalty
numList <- makeGapComb(10, 1)
n <- 1

for (i in numList) {
  s5 <- i[[1]]
  p1 <- i[[2]]
  p2 <- i[[2]]
  
  # make scoring matrix
  #scoringMatrix <- MakeFeatureMatrix(s5)
  
  # write the parameters information
  sink(paste("../Alignment/compare-", n, ".txt", sep = ""), append = T)
  print("Parameter:")
  print(paste("s5:  ", s5))
  print(paste("gap_open: ", p1))
  print(paste("gap_ext : ", p2))
  cat("\n")
  sink()
  
  for (f in filesPath) {
    
    # make correct align list
    alignedList <- MakeWordList(f["correct"])
    alignedList <- alignedList[-1]
    
    # execute pairwise alignment and get the results
    result <- ExecutePairWise(f["input"], s5, p1, p2)
    maxLengthWord <- result[["IndexOfMaxLengthWord"]]
    resultsMatrix <- result[["mat"]]
    
    # get the max length word
    corSeq1 <- alignedList[[maxLengthWord]]
    seq1 <- resultsMatrix[maxLengthWord, ]
    
    ## output the results after check results whether correct or wrong
    # for phonetic strings of all region
    correct <- 0
    rowOfResultsMat <- dim(resultsMatrix)[1]
    
    # output compare results
    sink(paste("../Alignment/compare-", n, ".txt", sep = ""), append = T)
    for (i in 1:rowOfResultsMat) {
      # correct
      if (resultsMatrix[i, ] == alignedList[[i]]) {
        correct <- correct + 1
      } else {
        # print a file name and wrong row
        print(paste(f["inName"]))
        print(i)
        
        # prepare output results
        corSeq1 <- paste(corSeq1, collapse = " ")
        corSeq2 <- paste(alignedList[[i]], collapse = " ")
        seq1 <- paste(seq1, collapse = " ")
        seq2 <- paste(resultsMatrix[i, ], collapse = " ")
        
        # print results
        print(paste("correct_seq1: ", corSeq1, sep = ""))
        print(paste("correct_seq2: ", corSeq2, sep = ""))
        print(paste("aligned_seq1: ", seq1, sep = ""))
        print(paste("aligned_seq2: ", seq2, sep = ""))
        cat("\n")
      }
    }
    sink()
    
    # output a correct answer rate
    sink(paste("../Alignment/ansrate-", n, ".txt", sep = ""), append = T)
    result <- paste(f["inName"], (correct)/(rowOfResultsMat)*100, sep = " ")
    print(result, quote = F)
    cat("\n")
    sink()
  }
  n <- n + 1
}