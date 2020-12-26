source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_ld <- function(word_list) {

  s <- MakeEditDistance(Inf)

  psa_rlt          <- list()
  psa_rlt$s        <- s
  psa_rlt$psa_list <- PSAforEachWord(word_list, s, dist = T)

  return(psa_rlt)
}


psa_pmi <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  psa_rlt <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)

  return(psa_rlt)
}


execute_psa <- function(method, word_list, output_dir, cv_sep) {

  num <- switch(method,
                "ld"     = 1,
                "pmi"    = 2,
                "pf-pmi" = 3
  )

  psa_rlt <- switch(num,
                     "1" = psa_ld(word_list),
                     "2" = psa_pmi(UpdatePMI, word_list, output_dir, cv_sep),
                     "3" = psa_pmi(UpdatePFPMI, word_list, output_dir, cv_sep)
  )

  return(psa_rlt)
}
