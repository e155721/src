.myfunc.env = new.env()
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

ExecutePairWise <- function(inputFile, s5, p1, p2)
{
  # make scoring matrix
  scoring_matrix <- MakeFeatureMatrix(s5)
    
  # remove original form
  wordList <- MakeWordList(inputFile)
  wordList <- wordList[-1]
  
  # search a max length word
  wLength <- c()
  for (w in wordList) {
    wLength <- append(wLength, length(w), length(wLength))
  }
  #names(wordList) <- wLength
  #seq1 <- wordList[[as.character(max(wLength))]]
  maxWordLength <- max(wLength)
  wordListLength <- length(wordList)
  for (i in 1:wordListLength) {
    if (length(wordList[[i]]) == maxWordLength){
      maxLengthWord <- i
      seq1 <- wordList[[i]]
    }
  }
  
  # execute pairwise alignment
  i <- 1
  alignLength <- c()
  alignList <- list()
  for (seq2 in wordList) {
    alignList[[i]] <- NeedlemanWunsch(seq1, seq2, p1, p2, scoring_matrix)[["seq2"]]
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
  result[["maxLengthWord"]] <- maxLengthWord
  result[["mat"]] <- resultsMatrix
  return(result)
}