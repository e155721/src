.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

wordList <- MakeWordList("../Alignment/input_data/005.dat")
wordList <- MakeWordList("../Alignment/input_data/018.dat")
wordList <- MakeWordList("../Alignment/input_data/001.dat")
seq1 <- wordList[[1]]
seq2 <- wordList[[2]]
seq2 <- wordList[[3]]

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3
m <- NeedlemanWunsch(seq1, seq1, s = scoringMatrix, p, p)
tmp(m$multi)

m <- NeedlemanWunsch(m$multi, seq1, s = scoringMatrix, p, p)
tmp(m$multi)

m <- NeedlemanWunsch(m$multi, seq1, s = scoringMatrix, p, p)
tmp(m$multi)

wl.len <- length(wordList)
seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s = scoringMatrix, p, p)
NeedlemanWunsch(seq1$multi, wordList[[3]], s = scoringMatrix, p, p)

for (i in 3:wl.len) {
  seq1 <- NeedlemanWunsch(seq1$multi, wordList[[i]], s = scoringMatrix, p, p)
  print(seq1$multi)
}
print(seq1$score)
tmp(seq1$multi)
