source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_lv <- function(word_list) {

  s        <- MakeEditDistance(Inf)
  msa_list <- MSAforEachWord(word_list, s)

  return(msa_list)
}
