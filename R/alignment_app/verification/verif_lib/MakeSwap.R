source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanSwap.R")

MakeSwap <- function(word.list, s)
{
  regions <- length(word.list)
  
  # pairwise alignments
  psa.aln <- list()
  
  m <- 2  
  n <- 1
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (l in m:regions) {
      psa <- NeedlemanSwap(as.matrix(word.list[[k]], drop = F),
                             as.matrix(word.list[[l]], drop = F), s)
      psa.aln[[n]] <- psa$seq1
      psa.aln[[n+1]] <- psa$seq2
      n <- n+2
    }
    # the end of the aligne for each the region pair
    m <- m + 1
  }
  
  return(psa.aln)
}
