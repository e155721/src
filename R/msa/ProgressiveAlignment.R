source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

source("psa/pf.R")
source("psa/pmi.R")
source("psa/pf-pmi.R")

ProgressiveAlignment <- function(word.list, s, method="PF") {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using progressive method.
  num.regions <- length(word.list)  # number of sequences
  dist.mat <- matrix(0, num.regions, num.regions)
  
  # Computes the pairwise alignment score for each regions pair.
  psa <- switch(method,
                "PF" = PairwisePF(word.list, s),
                "PMI" = PairwisePMI(word.list, s),
                "PF-PMI" = PairwisePFPMI(word.list, s)
  )
  
  if ((method == "PF") || method == "PF-PMI") {
    similarity <- T
  } else {
    similarity <- F
  }
  
  if (similarity) {
    min <- F
  } else {
    min <- T
  }
  
  # Makes the similarity matrix.
  reg.comb <- combn(1:num.regions, 2)
  N <- dim(reg.comb)[2]
  for (k in 1:N) {
    i <- reg.comb[1, k]
    j <- reg.comb[2, k]
    dist.mat[i, j] <- psa[[k]]$score
  }
  
  if (similarity) {
    # Calculates the PSA of identical pairs.  
    for (i in 1:num.regions)
      dist.mat[i, i] <- NeedlemanWunsch(word.list[[i]], word.list[[i]], s, select.min=min)$score
    
    # Converts the similarity matrix to the distance matrix.
    dist.mat.tmp <- t(dist.mat)
    dist.mat[lower.tri(dist.mat)] <- dist.mat.tmp[lower.tri(dist.mat.tmp)]
  }
  
  # Makes the guide tree.
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
      psa <- NeedlemanWunsch(word.list[[seq1]], word.list[[seq2]], s, select.min=min)
      pa[[i]] <- DelGap(psa$aln)
    } 
    else if(flg == 1) {
      clt <- gtree[i, 2]
      seq2 <- gtree[i, 1] * -1
      psa <- NeedlemanWunsch(pa[[clt]], word.list[[seq2]], s, select.min=min)
      pa[[i]] <- DelGap(psa$aln)
    } else {
      clt1 <- gtree[i, 1]
      clt2 <- gtree[i, 2]
      psa <- NeedlemanWunsch(pa[[clt1]], pa[[clt2]], s, select.min=min)
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
