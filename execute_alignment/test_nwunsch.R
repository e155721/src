.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

wordList <- MakeWordList("../Alignment/input_data/011.dat")
seq1 <- wordList[[1]]
seq2 <- wordList[[2]]

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3
NeedlemanWunsch(seq1, seq2, s = scoringMatrix, p, p)
