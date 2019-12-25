source("lib/load_verif_lib.R")

SelectMSA <- function(seq1, seq2, s.list, min) {
  
  msa.list <- foreach (p = 1:5) %dopar% {
    NeedlemanWunsch(seq1, seq2, s.list[[p]], select.min=min)
  }
  score.vec <- c(msa.list[[1]]$score, msa.list[[2]]$score, 
                 msa.list[[3]]$score, msa.list[[4]]$score, msa.list[[5]]$score)
  min.ind <- which(score.vec == min(score.vec))[1]
  msa <- msa.list[[min.ind]]
  
  return(msa)
}
