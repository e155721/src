source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_ld <- function(word_list) {

  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  return(psa_list)
}


psa_pmi <- function(method, word_list, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  pmi_rlt  <- PairwisePMI(psa_list, word_list, s, UpdatePMI, cv_sep)

  return(pmi_rlt)
}


execute_psa <- function(method, word_list, output_dir, cv_sep=T) {

  num <- switch(method,
                "ld"     = 1,
                "pmi"    = 2,
                "pf-pmi" = 3
  )

  psa_list <- switch(num,
                     "1" = psa_ld(word_list)
  )

  return(psa_list)
}
