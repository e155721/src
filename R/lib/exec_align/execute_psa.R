source("lib/load_pmi.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


psa_ld <- function(word_list, feat) {

  if (feat) {
    message("The LD used the features.")
    s <- MakeEditDistance2(Inf)  # using features
  } else {
    s <- MakeEditDistance(Inf)
  }

  psa_rlt          <- list()
  psa_rlt$s        <- s
  psa_rlt$psa_list <- PSAforEachWord(word_list, s)

  return(psa_rlt)
}


psa_pmi <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s)

  # Update the scoring matrix using the PMI.
  psa_rlt <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)

  return(psa_rlt)
}


psa_pf_pmi0 <- function(fun, word_list, output_dir, cv_sep) {

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s)

  # Update the scoring matrix using the PMI.
  psa_rlt <- PairwisePFPMI(psa_list, word_list, s, fun, cv_sep)

  return(psa_rlt)
}


psa_pf_pmi <- function(fun, word_list, output_dir, cv_sep, method) {

  message(paste("The PF-PMI", method, " was selected.", sep = ""))

  # Select a method for the PF-PMI.
  assign("g_pf_pmi", method, envir = .GlobalEnv)

  # Create an itnitial scoring matrix and a list of PSAs.
  s         <- MakeEditDistance(Inf)
  psa_list  <- PSAforEachWord(word_list, s)

  # Update the scoring matrix using the PMI.
  psa_rlt <- PairwisePMI(psa_list, word_list, s, fun, cv_sep)

  return(psa_rlt)
}


execute_psa <- function(method, word_list, output_dir, cv_sep) {

  num <- switch(method,
                "ld"      = 1,
                "ld2"     = 2,
                "pmi"     = 3,
                "pf-pmi0" = 4,
                "pf-pmi1" = 5,
                "pf-pmi2" = 6,
                "pf-pmi3" = 7
  )

  psa_rlt <- switch(num,
                    "1" = psa_ld(word_list, feat = F),
                    "2" = psa_ld(word_list, feat = T),
                    "3" = psa_pmi(UpdatePMI, word_list, output_dir, cv_sep),
                    "4" = psa_pf_pmi0(UpdatePFPMI0, word_list, output_dir, cv_sep),
                    "5" = psa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "1"),
                    "6" = psa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "2"),
                    "7" = psa_pf_pmi(UpdatePFPMI, word_list, output_dir, cv_sep, method = "3")
  )

  return(psa_rlt)
}
