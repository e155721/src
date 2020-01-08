source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")

SelectMSA <- function(seq1, seq2, s.list, min) {
  #s <- MakeEditDistance(Inf)
  load("../../Alignment/pmi/psa_11-14/scoring_matrix_pmi.RData")
  
  msa.list <- foreach (p = 1:5) %dopar% {
    NeedlemanWunsch(seq1, seq2, s.list[[p]], select.min=min)
  }
  score.vec <- c(CheckScore(msa.list[[1]]$aln, s),
                 CheckScore(msa.list[[2]]$aln, s),
                 CheckScore(msa.list[[3]]$aln, s),
                 CheckScore(msa.list[[4]]$aln, s),
                 CheckScore(msa.list[[5]]$aln, s))
  min.ind <- which(score.vec == min(score.vec))[1]
  msa <- msa.list[[min.ind]]
  msa$score <- min(score.vec)[1]
  return(msa)
}
