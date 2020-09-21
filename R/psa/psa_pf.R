source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_pf <- function(word_list, pen) {

  s        <- MakeFeatureMatrix(-Inf, pen)
  psa_list <- PSAforEachWord(word_list, s, dist = F)

  return(psa_list)
}
