source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")
source("lib/load_verif_lib.R")

ProgressiveAlignment <- function(word.list, s, similarity=T) {
  # Compute the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using progressive method.
  if (similarity) {
    min <- F
  } else {
    min <- T
  }
  
  # Compute the pairwise alignment score for each regions pair.
  psa <- MakePairwise(word.list, s, select.min=min)

  # Make the similarity matrix.
  num.regions <- length(word.list)  # number of sequences
  dist.mat <- matrix(0, num.regions, num.regions)
  reg.comb <- combn(1:num.regions, 2)
  N <- dim(reg.comb)[2]
  for (k in 1:N) {
    i <- reg.comb[1, k]
    j <- reg.comb[2, k]
    dist.mat[i, j] <- psa[[k]]$score
  }
  
  # Calculate the PSA of identical pairs.  
  if (similarity)
    for (i in 1:num.regions)
      dist.mat[i, i] <- NeedlemanWunsch(word.list[[i]], word.list[[i]], s, select.min=min)$score

  # Fill the distance matrix.
  dist.mat.tmp <- t(dist.mat)
  dist.mat[lower.tri(dist.mat)] <- dist.mat.tmp[lower.tri(dist.mat.tmp)]
    
  if (similarity) {
    # Convert the similarity matrix to the "dist" object.
    psa.d <- dist(dist.mat)
  } else {
    # Convert the distance matrix to the "dist" object.
    psa.d <- as.dist(dist.mat)
  }
  
  # Make the guide tree.
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
  
  # Return the list of progressive alignment results.
  msa <- list()
  msa$aln <- tail(pa, n = 1)[[1]]
  msa$score <- psa$score
  msa$gtree <- gtree
  return(msa)
}
