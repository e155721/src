Convert <- function(msa) {
  # Unify the gap insersions in the MSA.
  #
  # Args:
  #   msa: The msa.
  #
  # Returns:
  #  The MSA which was unified the gap insertions.
  dim.msa <- dim(msa)
  N <- dim.msa[2]
  
  for (j in 2:(N - 1)) {
    col1 <- msa[, j]
    col2 <- msa[, j + 1]
    
    num.gap1 <- sum(col1 == "-")
    num.gap2 <- sum(col2 == "-")
    
    rev <- sum((col1 != "-") + (col2 != "-") == 2)
    if (rev == 0) {
      if (num.gap1 <= num.gap2) {
        # NOP
      } else {
        msa[, j] <- col2
        msa[, j + 1] <- col1
      }
    }
  }
  
  return(msa)
}

CalcAccMSA <- function(msa.list, list.words, ansrate.file, output.dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa.list: The list of MSAs.
  #   list.words: The list of words that were used for the MSA.
  #   ansrate.file: The path of the matching rate file.
  #   output.dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.
  
  accuracy.mat <- matrix(NA, length(list.words), 2)
  
  for (w in list.words) {
    
    # Make the word list.
    gold.list <- MakeWordList(w["input"])  # gold alignment
    input.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Checks the accuracy of MSA.
    gold.mat <- DelGap(list2mat(gold.list))
    gold.mat <- gold.mat[order(gold.mat[, 1]), ]
    msa <- msa.list[[as.integer(w["id"])]]$aln
    msa <- msa[order(msa[, 1]), ]
    
    # Unified the gap insertion.
    msa       <- Convert(msa)
    gold.mat  <- Convert(gold.mat)
    
    # Calculates the MSA accuracy.
    M <- dim(msa)[1]
    matched <- 0
    for (i in 1:M) {
      aligned <- paste(msa[i, ], collapse = " ")
      gold <- paste(gold.mat[i, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    matching.rate <- (matched / M) * 100
    accuracy.mat <- rbind(accuracy.mat, c(w[["name"]], matching.rate))
    
    # Outputs the MSA.  
    write.table(msa, paste(output.dir, gsub("\\..*$", "", w["name"]), ".aln", sep=""), quote=F)
    write.table(gold.mat, paste(output.dir, gsub("\\..*$", "", w["name"]), ".lg", sep=""), quote=F)
  }
  
  # Outputs the accuracy file.
  write.table(accuracy.mat[-1:-length(list.words), , drop=F], ansrate.file, quote=F)
  
  return(0)
}
