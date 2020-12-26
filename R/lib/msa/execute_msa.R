source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_ld <- function(word_list) {

  s        <- MakeEditDistance(Inf)
  msa_list <- MSAforEachWord(word_list, s)

  return(msa_list)
}



psa_pmi <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  pmi_rlt  <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)
  pmi_list <- pmi_rlt$pmi_list
  s        <- pmi_rlt$s
  psa_list <- pmi_rlt$psa_list

  # Save the matrix of the PMIs and the scoring matrix.
  method <- attributes(fun)$method
  save(pmi_list, file = paste(output_dir, "/", "list_psa_", method, ".RData", sep = ""))
  save(s, file = paste(output_dir, "/", "score_psa_", method, ".RData", sep = ""))

  return(psa_list)
}


msa_pmi <- function(fun, word_list, output_dir, cv_sep) {

  # Update the scoring matrix using the PMI.
  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)
  s        <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)$s
  msa_pmi  <- MultiplePMI(word_list, s, fun, cv_sep)

  pmi_list <- msa_pmi$pmi_list
  s        <- msa_pmi$s
  msa_list <- msa_pmi$msa_list

  # Save the matrix of the PMIs and the scoring matrix.
  method <- attributes(fun)$method
  save(pmi_list, file = paste(output_dir, "/", "list_msa_", method, ".RData", sep = ""))
  save(s, file = paste(output_dir, "/", "score_msa_", method, ".RData", sep = ""))

  return(msa_list)
}


execute_msa <- function(method, word_list, output_dir, cv_sep=T) {

  num <- switch(method,
                "ld"     = 1,
                "pmi"    = 2,
                "pf-pmi" = 3
  )

  msa_list <- switch(num,
                     "1" = msa_ld(word_list),
                     "2" = msa_pmi(UpdatePMI, word_list, output_dir, cv_sep),
                     "3" = psa_pmi(UpdatePFPMI, word_list, output_dir, cv_sep)
  )

  return(msa_list)
}
