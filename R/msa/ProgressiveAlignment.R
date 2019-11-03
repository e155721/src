source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

source("psa/pf.R")

ProgressiveAlignment <- function(word.list, s) {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using progressive method.
  num.regions <- length(word.list)  # number of sequences
  dist.mat <- matrix(NA, num.regions, num.regions)
  
  # Computes the pairwise alignment score for each regions pair.
  psa <- PairwisePF(word.list, s)
  
  reg.comb <- combn(1:num.regions, 2)
  N <- dim(reg.comb)[2]
  for (k in 1:N) {
    i <- reg.comb[1, k]
    j <- reg.comb[2, k]
    dist.mat[i, j] <- psa[[k]]$score
  }

  dist.mat.tmp <- t(dist.mat)
  dist.mat[lower.tri(dist.mat)] <- dist.mat.tmp[lower.tri(dist.mat.tmp)]
  
  # Makes the guide tree.
  #dist.mat <- dist.mat[-dim(dist.mat)[1], , drop=F]
  psa.d <- dist(dist.mat)
  psa.hc <- hclust(psa.d, "average")
  gtree <- psa.hc$merge
  
  # START OF PROGRESSIVE ALIGNMENT
  pa <- list()
  len <- dim(gtree)[1]
  for (i in 1:len) {
    flg <- sum(gtree[i, ] < 0)
    if (flg == 2) {
      seq1 <- gtree[i, 1] * -1
      seq2 <- gtree[i, 2] * -1
      psa <- NeedlemanWunsch(word.list[[seq1]], word.list[[seq2]], s)
      pa[[i]] <- DelGap(psa$aln)
    } 
    else if(flg == 1) {
      clt <- gtree[i, 2]
      seq2 <- gtree[i, 1] * -1
      psa <- NeedlemanWunsch(pa[[clt]], word.list[[seq2]], s)
      pa[[i]] <- DelGap(psa$aln)
    } else {
      clt1 <- gtree[i, 1]
      clt2 <- gtree[i, 2]
      psa <- NeedlemanWunsch(pa[[clt1]], pa[[clt2]], s)
      pa[[i]] <- DelGap(psa$aln)
    }
  }
  # END OF PROGRESSIVE ALIGNMENT
  
  # Returns the list of progressive alignment results.
  msa <- list()
  msa$aln <- tail(pa, n = 1)[[1]]
  msa$score <- psa$score
  msa$gtree <- gtree
  return(msa)
}
