source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeEditDistance.R")
source("data_processing/MakeWordList.R")
source("verification/verif_lib/MakeInputSeq.R")

word.list <- MakeWordList("../../Alignment/org_data/002.org")
input.list <- MakeInputSeq(word.list)

seq1 <- input.list[[1]]
seq2 <- input.list[[2]]

s <- MakeEditDistance(Inf)

wl.len <- length(input.list)
NeedlemanWunsch(seq1, seq2, s, fmin = T)
