source("data_processing/DelGap.R")
source("lib/load_nwunsch.R")

MakeGoldStandard <- function(gold.list)
{
  
  regions <- length(gold.list)
  reg.comb <- combn(1:regions, 2)
  N <- dim(reg.comb)[2]
  
  gold.aln <- list()
  psa.list <- foreach (j = 1:N) %do% {
    i <- reg.comb[, j]
    gold.mat <- DelGap(rbind(gold.list[[i[1]]], gold.list[[i[2]]]))
    gold.aln[[j]] <- gold.mat
  }
  
  return(gold.aln)  
}