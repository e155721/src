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

seq1 <- matrix(NA, 2, 6)
seq1[1, ] <- c("p", "i", "t", "e", "ts", "u")
seq1[2, ] <- c("p", "i", "t", "e", "t", "-")

#seq1 <- t(matrix(c("p", "i", "t", "e", "ts", "u")))
seq2 <- t(matrix(c("tx", "i2", "t")))

scoringMatrix <- MakeFeatureMatrix(-10, -3)
p1 <- p2 <- -3
NeedlemanWunsch(seq1, seq2, s = scoringMatrix, p1, p2)
