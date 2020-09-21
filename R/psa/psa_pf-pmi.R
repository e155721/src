source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_pf_pmi <- function(word_list) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PF-PMI.
  pmi_rlt <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI, cv_sep = F)

  return(pmi_rlt)
}
