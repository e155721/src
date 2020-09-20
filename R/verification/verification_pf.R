source("lib/load_scoring_matrix.R")
source("lib/load_verif_lib.R")
source("lib/load_exec_align.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_pf"
dir <- "pairwise_pf"
ext = commandArgs(trailingOnly = TRUE)[1]

for (pen in -1) {

  if (is.na(ext)) {
    ext <- pen
  } else {
    ext <- paste(pen, "_", ext, sep = "")
  }
  path <- MakePath(file, dir, ext)

  # Make the scoring matrix.
  file_list <- GetPathList()
  word_list <- make_word_list(file_list)
  s <- MakeFeatureMatrix(-Inf, pen)
  psa.list <- PSAforEachWord(word_list, s, dist = F)
  VerificationPSA(psa.list, file_list, path$ansrate.file, path$output.dir)

}
