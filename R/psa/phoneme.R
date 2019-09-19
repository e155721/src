source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakePairwise.R")

Phoneme <- function(word.list, s) {
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s)
  psa.aln <- list2mat(psa.aln)
  return(psa.aln)
}
