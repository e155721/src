source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("verification_multiple/CalcAccMSA.R")
source("parallel_config.R")

ansrate <- "ansrate_msa_pf"
multiple <- "multiple_pf"
ext = commandArgs(trailingOnly=TRUE)[1]

list.words <- GetPathList()  # the list of words

for (pen in (-1)) {
  
  if (is.na(ext)) {
    ext <- pen
  } else {
    ext <- paste(pen, "_", ext, sep = "")
  }
  path <- MakePath(ansrate, multiple, ext)
  
  # Make the list of the MSAs.
  s <- MakeFeatureMatrix(-Inf, pen)
  msa.list <- MSAforEachWord(list.words, s, similarity=T)
  # Calculate the accuracy of the MSAs.
  CalcAccMSA(msa.list, list.words, path$ansrate.file, path$output.dir)
  
}
