.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("execute_alignment/ExecutePairWise.R", envir = .myfunc.env)
attach(.myfunc.env)

inputDirPath <- "../Alignment/input_data/"
inputFilesList <- list.files(inputDirPath)
inputFilesPath <- paste(inputDirPath, inputFilesList, sep = "")

correctDirPath <- "../Alignment/correct_data/"
correctFilesList <- list.files(correctDirPath)
correctFilesPath <- paste(correctDirPath, correctFilesList, sep = "")

# define a score and gap penaltys
s5 <- -2
p1 <- -5
p2 <- -5

# make scoring matrix
scoring_matrix <- MakeFeatureMatrix(s5)

corInd <- 1
for (f in inputFilesPath) {
  
  # make correct align list
  alignedList <- MakeWordList(correctFilesPath[[corInd]])
  alignedList <- alignedList[-1]
  corInd <- corInd + 1
  
  # execute pairwise alignment and get the results
  result <- ExecutePairWise(f, s5, p1, p2)
  maxLengthWord <- result[["maxLengthWord"]]
  resultsMatrix <- result[["mat"]]
  alnRow <- dim(resultsMatrix)[1]
  
  # get the max length word
  corSeq1 <- alignedList[[maxLengthWord]]
  seq1 <- resultsMatrix[maxLengthWord, ]
  
  # output the results after check results whether correct or wrong
  ## for phonetic strings of all region
  sink("../Alignment/compare.txt", append = T)
  correct <- 0
  for (i in 1:alnRow) {
    # correct
    if (resultsMatrix[i, ] == alignedList[[i]]) {
      correct <- correct + 1
    } else {
      # wrong
      # print a file name and wrong row
      print(f)
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
  sink("../Alignment/test.txt", append = T)
  result <- paste(f, (correct)/(alnRow)*100, sep = " ")
  print(result, quote = F)
  cat("\n")
  sink()
}