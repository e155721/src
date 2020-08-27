source("lib/load_verif_lib.R")

PairwiseLV  <- function(word.list, s) {
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s, select_min = T)
  return(psa.aln)
}
