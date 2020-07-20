source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")

LoadLib("msa/")

#word.list <- MakeWordList("../../Alignment/org_data/01-003首(2-2).org")
word.list <- MakeWordList("../../Alignment/org_data/01-003首(2-2).org", csv=F)
word.list <- MakeInputSeq(word.list)

s <- MakeFeatureMatrix(-Inf, -3)

RemoveFirst(word.list ,s)
BestFirst(word.list ,s)
Random(word.list, s)
