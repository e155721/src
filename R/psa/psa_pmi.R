source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")

psa_pmi <- function(word_list, cv_sep=F) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  pmi_rlt  <- PairwisePMI(psa_list, word_list, s, UpdatePMI, cv_sep)

  return(pmi_rlt)
}