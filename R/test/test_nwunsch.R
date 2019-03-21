source("needleman_wunsch/functions.R")
source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")

wordList <- MakeWordList("../../Alignment/input_data/002.input")
seq1 <- wordList[[1]]
seq2 <- wordList[[2]]
seq2 <- wordList[[3]]

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

wl.len <- length(wordList)
seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s = scoringMatrix)
NeedlemanWunsch(seq1$multi, wordList[[3]], s = scoringMatrix)

for (i in 3:wl.len) {
  seq1 <- NeedlemanWunsch(seq1$multi, wordList[[i]], s = scoringMatrix)
  print(seq1$multi)
}
print(seq1$score)
