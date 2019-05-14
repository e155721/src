source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")

wordList <- MakeWordList("../../Alignment/input_data/002.input")
seq1 <- wordList[[1]]
seq2 <- wordList[[2]]
seq2 <- wordList[[3]]

scoringMatrix <- MakeFeatureMatrix(10, 1)

wl.len <- length(wordList)
seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s = scoringMatrix)
NeedlemanWunsch(seq1$multi, wordList[[3]], s = scoringMatrix)

NeedlemanWunsch(matrix(c("v","r","a"), 1,3), matrix(c("v","a","r"),1,3), scoringMatrix)
