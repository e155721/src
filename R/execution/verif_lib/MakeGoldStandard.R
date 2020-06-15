source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")

MakeGoldStandard <- function(gold.list)
{
  regions <- length(gold.list)
  
  # gold alignments
  gold.aln <- list()
  
  # making gold standard
  m <- 2
  n <- 1
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (l in m:regions) {
      gold.mat <- DelGap(rbind(gold.list[[k]], gold.list[[l]]))
      gold.aln[[n]] <- gold.mat[1, , drop = F]
      gold.aln[[n+1]] <- gold.mat[2, , drop = F]
      n <- n+2
    }
    # the end of the aligne for each the region pair
    m <- m+1
  }
  
  return(gold.aln)  
}
