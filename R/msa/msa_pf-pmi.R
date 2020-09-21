source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_msa.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_pf_pmi <- function(word_list, cv_sep=F) {

  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)
  s        <- PairwisePMI(psa_list, word_list, s, UpdatePFPMI, cv_sep)$s
  msa_pmi  <- MultiplePMI(word_list, s, UpdatePFPMI)

  return(msa_pmi)
}
