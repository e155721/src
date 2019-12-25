source("lib/load_verif_lib.R")
source("test/check_score.R")
source("lib/load_scoring_matrix.R")

SelectPSA <- function(word.list, s.list, min) {
  s <- MakeEditDistance(Inf)
  
  # PSA for each pair.
  psa.list <- foreach (p = 1:5) %dopar% {
    MakePairwise(word.list, s.list[[p]], select.min=min)
  }
  
  N <- length(psa.list[[1]])
  psa <- list()
  for (i in 1:N) {
    score.vec <- c(CheckScore(psa.list[[1]][[i]]$aln, s),
                   CheckScore(psa.list[[2]][[i]]$aln, s),
                   CheckScore(psa.list[[3]][[i]]$aln, s),
                   CheckScore(psa.list[[4]][[i]]$aln, s),
                   CheckScore(psa.list[[5]][[i]]$aln, s))
    min.ind <- which(score.vec == min(score.vec))[1]
    psa[[i]] <- psa.list[[min.ind]][[i]]
  }
  
  return(psa)
}