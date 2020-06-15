source("lib/load_verif_lib.R")
source("test/check_score.R")
source("lib/load_scoring_matrix.R")

SelectPSA <- function(word.list, s.list, min) {
  #s <- MakeEditDistance(Inf)
  load("../../Alignment/pmi/psa_11-14/scoring_matrix_pmi.RData")
  
  # PSA for each pair.
  s.len <- length(s.list)
  psa.list <- foreach (p = 1:s.len) %dopar% {
    MakePairwise(word.list, s.list[[p]], select.min=min)
  }
  
  N <- length(psa.list[[1]])
  psa <- list()
  score.vec <- NULL
  for (i in 1:N) {
    for (j in 1:s.len) {
      score.vec[j] <- CheckScore(psa.list[[1]][[i]]$aln, s)
    }
    min.ind <- which(score.vec == min(score.vec))[1]
    psa[[i]] <- psa.list[[min.ind]][[i]]
    psa[[i]]$score <- min(score.vec)[1]
  }
  
  return(psa)
}
