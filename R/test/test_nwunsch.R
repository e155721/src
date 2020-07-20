source("needleman_wunsch/NeedlemanWunsch.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/MakeWordList.R")
source("verification/verif_lib/MakeInputSeq.R")

gold.list <- MakeWordList("../../Alignment/org_data/002.org")
input.list <- MakeInputSeq(gold.list)

seq1 <- gold.list[[1]]
seq2 <- gold.list[[2]]
seq2 <- gold.list[[3]]

s <- MakeFeatureMatrix(-Inf, -3)
p <- -3

wl.len <- length(gold.list)
seq1 <- NeedlemanWunsch(input.list[[1]], input.list[[2]], s)
NeedlemanWunsch(seq1$multi, input.list[[3]], s)

for (i in 3:wl.len) {
  seq1 <- NeedlemanWunsch(seq1$multi, input.list[[i]], s)
  print(seq1$multi)
}
print(seq1$score)

# 69
# 3827
