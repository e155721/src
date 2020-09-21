source("psa/psa_pf.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification/verification_psa.R")

file <- "ansrate_pf"
dir <- "pairwise_pf"
ext <- commandArgs(trailingOnly = TRUE)[1]

for (pen in -1) {

  if (is.na(ext)) {
    ext <- pen
  } else {
    ext <- paste(pen, "_", ext, sep = "")
  }
  path <- MakePath(file, dir, ext)

  file_list <- GetPathList()
  word_list <- make_word_list(file_list)

  psa_list <- psa_pf(word_list, pen)

  VerificationPSA(psa_list, file_list, path$ansrate.file, path$output.dir)

}
