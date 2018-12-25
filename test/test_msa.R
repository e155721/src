.myfunc.env = new.env()
sys.source("data_processing/MakeFeatureList.R", envir = .myfunc.env)
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/RemoveFirst.R", envir = .myfunc.env)
sys.source("verification_multiple/BestFirst.R", envir = .myfunc.env)
sys.source("verification_multiple/check_nwunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

wordList <- MakeWordList("../Alignment/input_data/001.dat")
p <- -3
s <- MakeFeatureMatrix(-10, p)

pa <- ProgressiveAlignment(wordList, p, s)
rf <- RemoveFirst(wordList, p, s)
bf <- BestFirst(wordList, p, s)