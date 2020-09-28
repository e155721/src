source("msa/msa_pf.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pf"
multiple <- "multiple_pf"
ext <- commandArgs(trailingOnly = TRUE)[1]

for (pen in (-1)) {

  if (is.na(ext)) {
    ext <- pen
  } else {
    ext <- paste(pen, "_", ext, sep = "")
  }
  path <- MakePath(ansrate, multiple, ext)

  # Make the list of the MSAs.
  file_list <- GetPathList()
  word_list <- make_word_list(file_list)

  msa_list <- msa_pf(word_list, pen)

  # Calculate the accuracy of the MSAs.
  verification_msa(msa_list, file_list, path$ansrate.file, path$output.dir)

}
