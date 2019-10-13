source("lib/load_nwunsch.R")

MakePairwise <- function(word.list, s, select.min=F)
{

  regions <- length(word.list)
  reg.comb <- combn(1:regions, 2)
  N <- dim(reg.comb)[2]
  
  psa.list <- foreach (j = 1:N) %dopar% {
    i <- reg.comb[, j]
    psa <- NeedlemanWunsch(as.matrix(word.list[[i[1]]], drop = F),
                           as.matrix(word.list[[i[2]]], drop = F), s, select.min)
  }
  
  return(psa.list)
}
