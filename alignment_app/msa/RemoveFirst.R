source("msa/ProgressiveAlignment.R")
source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

RemoveFirst <- function(word.list, s) {
  # Computes the multiple alignment using remove first method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment by remove first method.
  
  # Computes the initial multiple alignment using the progressive method.
  msa.tmp <- ProgressiveAlignment(word.list, s)
  msa <- msa.tmp$aln
  score <- msa.tmp$score
  
  N <- dim(msa)[1]  # number of sequences
  count <- 0  # loop counter
  max <- 2 * N * N  # max iteration
  
  # --> START OF ITERATION
  i <- 1
  while (i <= N) {
    
    # Determines the exit condition.
    if (count == max) {
      break
    }
    
    # Removes the first sequence.
    seq1 <- msa[i, , drop = F]
    seq2 <- msa[-i, , drop = F]

    # Makes the new multiple alignment.
    msa.tmp<- NeedlemanWunsch(seq1, seq2, s)
    msa.new <- DelGap(msa.tmp$aln)
    score.new <- msa.tmp$score
    
    # Refines the alignment score.
    if (score.new > score) {
      count <- count + 1
      msa <- msa.new
      score <- score.new
    } else {
      i <- i + 1
    }
    
  }
  # END OF ITERATION <--
  
  return(msa)
}
