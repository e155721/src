source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


msa_ld <- function(word_list, feat) {

  if (feat) {
    message("The LD used the features.")
    s <- MakeEditDistance2(Inf)  # using features
  } else {
    s <- MakeEditDistance(Inf)
  }

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
  rm(psa_list)
  gc()
  gc()
  msa_rlt  <- MultiplePMI(word_list, s, fun, cv_sep)

  return(msa_rlt)
}


msa_pf_pmi0 <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  s        <- PairwisePFPMI(psa_list, word_list, s, fun, cv_sep)$s
  rm(psa_list)
  gc()
  gc()
  msa_rlt  <- MultiplePMI(word_list, s, fun, cv_sep)

  return(msa_rlt)
}


msa_pf_pmi <- function(fun, word_list, output_dir, cv_sep, method) {

  message(paste("The PF-PMI", method, " was selected.", sep = ""))

  # Select a method for the PF-PMI.
  assign("g_pf_pmi", method, envir = .GlobalEnv)

  # Create an itnitial scoring matrix and a list of PSAs.
  s        <- MakeEditDistance(Inf)
  psa_list <- PSAforEachWord(word_list, s, dist = T)

  # Update the scoring matrix using the PMI.
  s        <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)$s
  rm(psa_list)
  gc()
  gc()
  msa_rlt  <- MultiplePMI(word_list, s, fun, cv_sep)

  return(msa_rlt)
}


execute_msa <- function(method, word_list, output_dir, cv_sep) {

  num <- switch(method,
                "ld"      = 1,
                "ld2"     = 2,
                "pmi"     = 3,
                "pf-pmi0" = 4,
                "pf-pmi1" = 5,
                "pf-pmi2" = 6,
                "pf-pmi3" = 7
  )

  msa_rlt <- switch(num,
                    "1" = msa_ld(word_list, feat = F),
                    "2" = msa_ld(word_list, feat = T),
                    "3" = msa_pmi(UpdatePMI, word_list, output_dir, cv_sep),
                    "4" = msa_pf_pmi0(UpdatePFPMI0, word_list, output_dir, cv_sep),
                    "5" = msa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "1"),
                    "6" = msa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "2"),
                    "7" = msa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "3")
  )

  return(msa_rlt)
}
