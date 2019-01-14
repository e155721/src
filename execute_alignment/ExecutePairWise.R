
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")


ExecutePairWise <- function(inputFile, s5, p1, p2)
{
  # make scoring matrix
  scoringMatrix <- MakeFeatureMatrix(s5)
  
  # remove original form
  wordList <- MakeWordList(inputFile)
  wordList <- wordList[-1]
  
  # search a max length word
  wordLength <- c()
  for (w in wordList) {
    wordLength <- append(wordLength, length(w), length(wordLength))
  }

  # names(wordList) <- wLength
  # seq1 <- wordList[[as.character(max(wLength))]]
  
  maxWordLength <- max(wordLength)
  wordListLength <- length(wordList)
  for (i in 1:wordListLength) {
    if (length(wordList[[i]]) == maxWordLength){
      IndexOfMaxLengthWord <- i
      seq1 <- wordList[[i]]
      break
    }
  }
  
  # execute pairwise alignment
  i <- 1
  alignLength <- c()
  alignList <- list()
  for (seq2 in wordList) {
    alignList[[i]] <- NeedlemanWunsch(seq1, seq2, p1, p2, scoringMatrix)[["seq2"]]
    alignLength <- append(alignLength, length(alignList[[i]]))
    i <- i + 1
  }
  
  # search a max length alignment
  names(alignList) <- alignLength
  wlRow <- length(alignList)
  wlCol <- max(alignLength)
  resultsMatrix <- matrix(NA, wlRow, wlCol)
  
  # make resultsMatrix after filled a blank of alignment result
  i <- 1
  for (aln in alignList) {
    alnCol <- length(aln)
    diff <- wlCol - alnCol
    if (diff != 0) {
      for (k in 1:diff) {
        aln <- append(aln, NA, length(aln))
      }
    }
    resultsMatrix[i, ] <- aln
    i <- i + 1
  }
  
  result <- list(NA, NA)
  names(result) <- c("seq1", "mat") 
  result[["IndexOfMaxLengthWord"]] <- IndexOfMaxLengthWord
  result[["mat"]] <- resultsMatrix
  return(result)
}
