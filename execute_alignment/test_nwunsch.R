.myfunc.env = new.env()
sys.source("needleman_wunsch/functions.R", envir = .myfunc.env)
sys.source("needleman_wunsch/needlemanWunsch.R", envir = .myfunc.env)
sys.source("needleman_wunsch/makeScoringMatrix.R", envir = .myfunc.env)
attach(.myfunc.env)

scoring_matrix <- makeScoringMatrix()
needlemanWunsch(c("a","i"), c("i", "i", "a"), scoring_matrix = scoring_matrix)
