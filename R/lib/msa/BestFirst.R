source("lib/load_data_processing.R")
source("lib/load_nwunsch.R")

source("lib/load_scoring_matrix.R")

BestFirst <- function(msa, s, similarity=T) {
  # Computes the multiple alignment using progressive method.
  #
  # Args:
  #   word.list: The list of sequences.
  #   s: The scoring matrix.
  #
  # Returns:
  #   The multiple alignment using best first method.

  word <- attributes(msa)$word

  # Computes the initial multiple alignment using the progressive method.
  N <- dim(msa$aln)[1]  # number of sequences
  count <- 0  # loop counter
  max <- 2 * N * N  # max iteration

  if (similarity) {
    min <- F
  } else {
    min <- T
  }

  # START OF ITERATION
  while (1) {

    # Determines the exit condition.
    if (count == max) {
      break
    }

    # Makes the multiple alignment.
    msa.new <- foreach(i = 1:N) %dopar% {
      # Removes the ith sequence.
      seq1 <- msa$aln[drop = F, i, ]
      seq2 <- DelGap(msa$aln[drop = F, -i, ])
      needleman_wunsch(seq1, seq2, s, select_min = min)
    }

    score.vec <- c()
    for (i in 1:N)
      score.vec[i] <- msa.new[[i]]$score

    # Refines the alignment score.
    if (similarity) {
      # Find a maximum MSA score.
      score.max <- grep(score.vec, pattern = max(score.vec))
      score.max <- score.max[1]
      score.new <- score.vec[score.max]

      if (score.new > msa$score) {
        count <- count + 1
        msa <- list()
        msa$aln <- DelGap(msa.new[[score.max]]$aln)
        msa$score <- score.new
      } else {
        break
      }
    } else {
      # Find a minimum MSA score.
      score.min <- grep(score.vec, pattern = min(score.vec))
      score.min <- score.min[1]
      score.new <- score.vec[score.min]

      if (score.new < msa$score) {
        count <- count + 1
        msa <- list()
        msa$aln <- DelGap(msa.new[[score.min]]$aln)
        msa$score <- score.new
      } else {
        break
      }
    }

  }
  # END OF ITERATION

  attributes(msa) <- list(names = attributes(msa)$names, word = word)
  return(msa)
}
