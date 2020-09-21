Convert <- function(msa) {
  # Unify the gap insersions in the MSA.
  #
  # Args:
  #   msa: The msa.
  #
  # Returns:
  #  The MSA which was unified the gap insertions.
  dim_msa <- dim(msa)
  N <- dim_msa[2]

  for (j in 2:(N - 1)) {
    col1 <- msa[, j]
    col2 <- msa[, j + 1]

    num_gap1 <- sum(col1 == "-")
    num_gap2 <- sum(col2 == "-")

    rev <- sum((col1 != "-") + (col2 != "-") == 2)
    if (rev == 0) {
      if (num_gap1 <= num_gap2) {
        # NOP
      } else {
        msa[, j] <- col2
        msa[, j + 1] <- col1
      }
    }
  }

  return(msa)
}