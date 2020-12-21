source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")
source("lib/load_verif_lib.R")

ProgressiveAlignment <- function(seq_list, s, similarity=T) {
  # Compute the multiple alignment using progressive method.
  #
  # Args:
  #   seq_list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:

  word <- attributes(seq_list)$word

  #   The multiple alignment using progressive method.
  if (similarity) {
    min <- F
  } else {
    min <- T
  }

  # Compute the pairwise alignment score for each regions pair.
  psa <- MakePairwise(seq_list, s, select_min=min)

  # Make the similarity matrix.
  num.regions <- length(seq_list)  # number of sequences
  dist.mat <- matrix(0, num.regions, num.regions)
  reg.comb <- combn(1:num.regions, 2)
  N <- dim(reg.comb)[2]
  for (k in 1:N) {
    i <- reg.comb[1, k]
    j <- reg.comb[2, k]
    dist.mat[i, j] <- psa[[k]]$score
  }

  # Calculate the PSA of identical pairs.
  if (similarity) {
    dist.mat <- -dist.mat
    dist.max <- max(dist.mat[upper.tri(dist.mat, diag = T)])
    dist.min <- min(dist.mat[upper.tri(dist.mat, diag = T)])
    dist.mat[upper.tri(dist.mat, diag = T)] <- (dist.mat[upper.tri(dist.mat, diag = T)] - dist.min) / (dist.max - dist.min)
  }

  # Fill the distance matrix.
  dist.mat.tmp <- t(dist.mat)
  dist.mat[lower.tri(dist.mat)] <- dist.mat.tmp[lower.tri(dist.mat.tmp)]

  # Convert the distance matrix to the "dist" object.
  psa.d <- as.dist(dist.mat)

  # Make the guide tree.
  psa.hc <- hclust(psa.d, "average")
  gtree <- psa.hc$merge

  # START OF PROGRESSIVE ALIGNMENT
  pa.list <- list()
  len <- dim(gtree)[1]
  for (i in 1:len) {
    flg <- sum(gtree[i, ] < 0)
    if (flg == 2) {
      seq1 <- gtree[i, 1] * -1
      seq2 <- gtree[i, 2] * -1
      pa <- needleman_wunsch(seq_list[[seq1]], seq_list[[seq2]], s, select_min=min)
      pa.list[[i]] <- DelGap(pa$aln)
    }
    else if (flg == 1) {
      clt <- gtree[i, 2]
      seq2 <- gtree[i, 1] * -1
      pa <- needleman_wunsch(pa.list[[clt]], seq_list[[seq2]], s, select_min=min)
      pa.list[[i]] <- DelGap(pa$aln)
    } else {
      clt1 <- gtree[i, 1]
      clt2 <- gtree[i, 2]
      pa <- needleman_wunsch(pa.list[[clt1]], pa.list[[clt2]], s, select_min=min)
      pa.list[[i]] <- DelGap(pa$aln)
    }
  }
  # END OF PROGRESSIVE ALIGNMENT

  # Return the list of progressive alignment results.
  msa <- list()
  msa$aln <- tail(pa.list, n = 1)[[1]]
  msa$score <- pa$score
  msa$gtree <- gtree

  attributes(msa) <- list(names = attributes(msa)$names, word = word)
  return(msa)
}
