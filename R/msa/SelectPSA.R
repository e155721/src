source("lib/load_verif_lib.R")

SelectPSA <- function(word.list, s.list, min) {
  
  # PSA for each pair.
  psa.list <- foreach (p = 1:5) %dopar% {
    MakePairwise(word.list, s.list[[p]], select.min=min)
  }
  
  N <- length(psa.list[[1]])
  psa <- list()
  for (i in 1:N) {
    score.vec <- c(psa.list[[1]][[i]]$score,
                   psa.list[[2]][[i]]$score,
                   psa.list[[3]][[i]]$score,
                   psa.list[[4]][[i]]$score,
                   psa.list[[5]][[i]]$score)
    min.ind <- which(score.vec == min(score.vec))[1]
    psa[[i]] <- psa.list[[min.ind]][[i]]
  }
  
  return(psa)
}