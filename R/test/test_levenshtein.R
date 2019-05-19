source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/nw_lib/functions.R")
source("data_processing/MakeWordList.R")

wordList <- MakeWordList("../../Alignment/input_data/002.input")
seq1 <- wordList[[1]]
seq2 <- wordList[[2]]

s <- MakeEditDistance(10)

wl.len <- length(wordList)
seq1 <- NeedlemanWunsch(wordList[[1]], wordList[[2]], s, fmin = T)
