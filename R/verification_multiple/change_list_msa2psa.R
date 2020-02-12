source("lib/load_data_processing.R")
source("test/check_score.R")

ChangeListMSA2PSA <- function(msa.list, s) {
  # Make the word list of all the words.
  #
  # Args:
  #   files: The files path of all the words.
  #
  # Returns:
  #   psa.list: The word list of all the words.
  psa.list <- list()
  num.msa <- length(msa.list)
  for (i in 1:num.msa) {
    num.reg <- dim(msa.list[[i]]$aln)[1]
    comb.reg <- combn(1:num.reg, 2)
    N <- dim(comb.reg)[2]
    psa.list[[i]] <- list()
    
    for (j in 1:N) {
      aln <- rbind(msa.list[[i]]$aln[comb.reg[1, j], ],
                   msa.list[[i]]$aln[comb.reg[2, j], ])
      aln <- DelGap(aln)
      seq1 <- aln[1, , drop=F]
      seq2 <- aln[2, , drop=F]
      
      psa.list[[i]][[j]] <- list()
      psa.list[[i]][[j]]$seq1 <- seq1
      psa.list[[i]][[j]]$seq2 <- seq2
      psa.list[[i]][[j]]$aln <- aln
      psa.list[[i]][[j]]$score <- CheckScore(aln, s)
    }
  }
  
  return(psa.list)
}
