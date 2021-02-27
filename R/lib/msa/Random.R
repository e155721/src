source("lib/msa/ProgressiveAlignment.R")
source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

Random <- function(msa, s) {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using random method.

  word <- attributes(msa)$word

  # Computes the initial multiple alignment using the progressive method.
  N <- dim(msa$aln)[1]  # number of sequences
  score <- msa$score
  count <- 0  # loop counter
  max <- 2 * N * N  # max iteration

  # --> START OF ITERATION
  i <- 0
  while (1) {

    # Determines the exit condition.
    if ((i == N) || (count == max))
      break

    # Separates the MSA at random point.
    R <- floor(runif(1, min = 2, max = N + 1))
    seq1 <- msa$aln[1:(R - 1), , drop = F]
    seq2 <- msa$aln[R:N, , drop = F]

    seq1_row <- dim(seq1)[1]
    seq2_row <- dim(seq2)[1]

    if (seq1_row != 1) seq1 <- DelGap(seq1)
    if (seq2_row != 1) seq2 <- DelGap(seq2)

    # Computes the new MSA.
    msa.tmp <- needleman_wunsch(seq1, seq2, s)
    msa.new <- DelGap(msa.tmp$aln)
    score.new <- msa.tmp$score

    # Refine the alignment score.
    if (score.new < msa$score) {
      count <- count + 1
      msa <- msa.new
      score <- score.new
    } else {
      i <- i + 1
    }

  }
  # END OF ITERATION <--

  attributes(msa) <- list(names = attributes(msa)$names, word = word)
  return(msa)
}
