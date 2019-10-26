source("lib/load_verif_lib.R")

PairwisePF <- function(word.list, s) {
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s)
  return(psa.aln)
}
