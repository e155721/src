source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_ld <- function(word_list) {

  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  return(psa_list)
}


execute_psa <- function(method, word_list, output_dir, cv_sep=T) {

  if (method == "ld") {
    psa_list <- psa_ld(word_list)
  } else {

  }

  return(psa_list)
}
