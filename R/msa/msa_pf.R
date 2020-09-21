source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_pf <- function(word_list, pen) {

  s        <- MakeFeatureMatrix(-Inf, pen)
  msa_list <- MSAforEachWord(word_list, s, similarity = T)

  return(msa_list)
}
