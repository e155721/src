.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

seq1 <- c("n", "a") 
seq2 <- c("n", "a:")

seq1 <- c("?", "a", "a", "ts2x", "i:")
seq2 <- c("a", "k", "a", "ts", "y")
seq2 <- c("k", "a:", "ts", "y")

seq1 <- c("p", "i", "t", "e", "ts", "u")
seq2 <- c("tx", "i2", "t")

scoringMatrix <- MakeScoringMatrix()
scoringMatrix <- MakeFeatureMatrix(-2)
NeedlemanWunsch(seq1, seq2, s = scoringMatrix, p1 = -5, p2 = -5)
