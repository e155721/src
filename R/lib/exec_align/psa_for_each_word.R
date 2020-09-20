library(doMC)

source("lib/load_verif_lib.R")

PSAforEachWord <- function(word_list, s, dist = F) {
  # Compute the PSA for each word.
  # Args:
  #   s: The scoring matrix.
  #   dist: The PSA will be using a distance or not.
  #
  # Returns:
  #   The list of PSA for each word.

  # START OF LOOP
  print("PSAforEachWord")
  psa_list <- foreach(seq_list = word_list) %dopar% {

    # Compute the PSA for each region.
    psa <- MakePairwise(seq_list, s, select_min=dist)

    return(psa)
  }

  return(psa_list)
}
