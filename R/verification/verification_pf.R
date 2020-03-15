source("lib/load_scoring_matrix.R")
source("lib/load_verif_lib.R")
source("psa/psa_for_each_word.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_pf"
dir <- "pairwise_pf"
ext = commandArgs(trailingOnly=TRUE)[1]

for (pen in -1) {
  
  if (is.na(ext)) {
    ext <- pen
  } else {
    ext <- paste(pen, "_", ext, sep = "")
  }
  path <- MakePath(file, dir, ext)
  
  # Make the scoring matrix.
  list.words <- GetPathList()
  s <- MakeFeatureMatrix(-Inf, pen)
  psa.list <- PSAforEachWord(list.words, s, dist = F)
  VerificationPSA(psa.list, path$ansrate.file, path$output.dir)
  
}
