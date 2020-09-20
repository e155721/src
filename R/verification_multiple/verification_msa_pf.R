source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")

ansrate <- "ansrate_msa_pf"
multiple <- "multiple_pf"
ext = commandArgs(trailingOnly = TRUE)[1]

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
  s <- MakeFeatureMatrix(-Inf, pen)
  msa.list <- MSAforEachWord(word_list, s, similarity = T)
  # Calculate the accuracy of the MSAs.
  verification_msa(msa.list, file_list, path$ansrate.file, path$output.dir)

}
