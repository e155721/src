source("lib/msa/ProgressiveAlignment.R")
source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

Random <- function(word.list, s) {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using random method.
  N <- length(word.list)  # number of sequences
  # Computes the initial multiple alignment using the progressive method.
  msa.tmp <- ProgressiveAlignment(word.list, s)
  msa <- msa.tmp$aln
  score <- msa.tmp$score

  # number of sequences
  N <- dim(msa)[1]

  count <- 0  # loop counter
  max <- 2 * N * N  # number of max iteration

  # --> START OF ITERATION
  i <- 0
  while (1) {

    # Determines the exit condition.
    if ((i == N) || (count == max))
      break

    # Separates the MSA at random point.
    R <- floor(runif(1, min = 2, max = N + 1))
    seq1 <- msa[1:(R - 1), , drop = F]
    seq2 <- msa[R:N, , drop = F]

    seq1_row <- dim(seq1)[1]
    seq2_row <- dim(seq2)[1]

    if (seq1_row != 1) seq1 <- DelGap(seq1)
    if (seq2_row != 1) seq2 <- DelGap(seq2)

    # Computes the new MSA.
    msa.tmp <- needleman_wunsch(seq1, seq2, s)
    msa.new <- DelGap(msa.tmp$aln)
    score.new <- msa.tmp$score

    # Refines alignment score.
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
