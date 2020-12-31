source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

RemoveFirst <- function(msa, s, similarity=T) {
  # Compute the multiple alignment using remove first method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment by remove first method.

  # Compute the initial multiple alignment using the progressive method.
  N <- dim(msa$aln)[1]   # number of sequences
  score <- msa$score
  count <- 0         # loop counter
  kMax <- 2 * N * N  # max iteration

  if (similarity) {
    min <- F
  } else {
    min <- T
  }

  # START OF ITERATION
  i <- 1
  while (i <= N) {

    # Check the exit condition.
    if (count == kMax)
      break

    # Remove the first sequence.
    seq1 <- msa$aln[i, , drop = F]
    seq2 <- DelGap(msa$aln[-i, , drop = F])

    # Make the new multiple alignment.
    msa.tmp <- needleman_wunsch(seq1, seq2, s)
    msa.new <- DelGap(msa.tmp$aln)
    score.new <- msa.tmp$score

    # Refine the alignment score.
    if (similarity) {
      if (score.new > score) {
        count <- count + 1
        msa <- msa.new
        score <- score.new
      } else {
        i <- i + 1
      }
    } else {
      if (score.new < score) {
        count <- count + 1
        msa <- msa.new
        score <- score.new
      } else {
        i <- i + 1
      }
    }

  }
  # END OF ITERATION

  return(msa)
}
