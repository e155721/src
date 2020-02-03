source("test/check_score.R")

list.msa2psa <- function(msa.list, s) {
  # Make the word list of all the words.
  #
  # Args:
  #   files: The files path of all the words.
  #
  # Returns:
  #   psa.list: The word list of all the words.
  # Make the similarity matrix.
  psa.list <- list()
  num.msa <- length(msa.list)
  for (i in 1:num.msa) {
    num.reg <- dim(msa.list[[i]]$aln)[1]
    comb.reg <- combn(1:num.reg, 2)
    N <- dim(comb.reg)[2]
    psa.list[[i]] <- list()
    
    for (j in 1:N) {
      seq1 <- msa.list[[i]]$aln[comb.reg[1, j], , drop=F]
      seq2 <- msa.list[[i]]$aln[comb.reg[2, j], , drop=F]
      aln <- rbind(seq1, seq2)
      
      psa.list[[i]][[j]] <- list()
      psa.list[[i]][[j]]$seq1 <- seq1
      psa.list[[i]][[j]]$seq2 <- seq2
      psa.list[[i]][[j]]$aln <- aln
      psa.list[[i]][[j]]$score <- CheckScore(aln, s)
    }
  }
  
  return(psa.list)
}
