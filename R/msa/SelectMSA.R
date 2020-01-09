source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")

SelectMSA <- function(seq1, seq2, s.list, min) {
  #s <- MakeEditDistance(Inf)
  load("../../Alignment/pmi/psa_11-14/scoring_matrix_pmi.RData")
  
  s.len <- length(s.list)
  msa.list <- foreach (p = 1:s.len) %dopar% {
    NeedlemanWunsch(seq1, seq2, s.list[[p]], select.min=min)
  }
  score.vec <- NULL
  for (i in 1:s.len) {
    score.vec[i] <- CheckScore(msa.list[[i]]$aln, s)
  }
  min.ind <- which(score.vec == min(score.vec))[1]
  msa <- msa.list[[min.ind]]
  msa$score <- min(score.vec)[1]
  return(msa)
}
