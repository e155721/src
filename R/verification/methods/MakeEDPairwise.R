source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

MakeEDPairwise <- function(word.list, s, select.min=F)
{
  regions <- length(word.list)
  
  # pairwise alignments
  psa.aln <- list()
  
  # edit distance
  ed <- 0
  
  # return
  psa.rlt <- list(NA, NA)
  names(psa.rlt) <- c("psa", "ed")
  
  m <- 2  
  n <- 1
  for (k in 1:(regions-1)) {
    # the start of the alignment for each the region pair
    for (l in m:regions) {
      psa <- NeedlemanWunsch(as.matrix(word.list[[k]], drop = F),
                             as.matrix(word.list[[l]], drop = F), s, select.min)
      psa.aln[[n]] <- psa$seq1
      psa.aln[[n+1]] <- psa$seq2
      psa.aln[[n+2]] <- " "
      ed <- ed+psa$score
      n <- n+3
    }
    # the end of the aligne for each the region pair
    m <- m + 1
  }
  
  psa.rlt$psa <- psa.aln
  psa.rlt$ed <- ed
  
  return(psa.rlt)
}
