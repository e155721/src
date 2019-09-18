library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("msa/ProgressiveAlignment.R")
source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

BestFirst <- function(word.list, s) {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using best first method.
  N <- length(word.list)  # number of sequences
  
  # Computes the initial multiple alignment using the progressive method.
  msa.tmp <- ProgressiveAlignment(word.list, s)
  msa <- msa.tmp$aln
  score <- msa.tmp$score
  
  N <- dim(msa)[1]  # number of sequences
  count <- 0  # loop counter
  max <- 2 * N * N  # max iteration
  
  # --> START OF ITERATION
  while (1) {
    
    # Determines the exit condition.
    if (count == max) {
      break
    }
    
    # Makes the multiple alignment.
    msa.new <- foreach (i = 1:N) %dopar% {
      # Removes the ith sequence.
      seq1 <- msa[drop = F, i, ]
      seq2 <- msa[drop = F, -i, ]
      NeedlemanWunsch(seq1, seq2, s)
    }
    
    score.vec <- c()
    for (i in 1:N)
      score.vec[i] <- msa.new[[i]]$score
    
    score.max <- grep(score.vec, pattern = max(score.vec))
    score.max <- score.max[1]
    score.new <- score.vec[score.max]
    
    # Refines the alignment score.
    if (score.new > score) {
      count <- count + 1
      msa <- DelGap(msa.new[[score.max]]$aln)
      score <- score.new
    } else {
      break
    }
    
  }
  # END OF ITERATION <--
    
  return(msa)
}
