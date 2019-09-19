source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakePairwise.R")

Levenshtein <- function(word.list) {
  # making the pairwise alignment in all regions
  s <- MakeEditDistance(Inf)
  psa.aln <- MakePairwise(word.list, s, select.min = T)
  psa.aln <- list2mat(psa.aln)
  return(psa.aln)
}
