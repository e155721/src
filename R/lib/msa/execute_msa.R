source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_ld <- function(word_list) {

  s <- MakeEditDistance(Inf)

  msa_rlt          <- list()
  msa_rlt$s        <- s
  msa_rlt$msa_list <- MSAforEachWord(word_list, s)

  return(msa_rlt)
}


msa_pmi <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  s        <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)$s
  msa_rlt  <- MultiplePMI(word_list, s, fun, cv_sep)

  return(msa_rlt)
}


execute_msa <- function(method, word_list, output_dir, cv_sep) {

  num <- switch(method,
                "ld"     = 1,
                "pmi"    = 2,
                "pf-pmi" = 3
  )

  msa_rlt <- switch(num,
                     "1" = msa_ld(word_list),
                     "2" = msa_pmi(UpdatePMI, word_list, output_dir, cv_sep),
                     "3" = msa_pmi(UpdatePFPMI, word_list, output_dir, cv_sep)
  )

  return(msa_rlt)
}
