source("psa/psa_for_all_words.R")
source("verification/verification_psa.R")
source("lib/load_scoring_matrix.R")
source("parallel_config.R")


VerificationLV <- function(file, dir, ext) {
  
  if (is.na(ext)) {
    ext <- NULL
  } else {
    ext <- paste(ext, "_", sep = "")
  }
  
  # Set the path of the matching rate.
  ansrate.file <- paste("../../Alignment/", file, "_", format(Sys.Date()), ".txt", sep = "")
  
  # Set the path of the PSA directory.
  output.dir <- paste("../../Alignment/", dir, "_", format(Sys.Date()), "/", sep = "")
  if (!dir.exists(output.dir))
    dir.create(output.dir)
  
  # Execute the PSA for each word.
  s <- MakeEditDistance(Inf)
  psa.list <- PSAforAllWrods(s, dist=F)
  VerificationPSA(psa.list, ansrate.file, output.dir)
  
}

file <- "ansrate_lv"
dir <- "pairwise_lv"
ext = commandArgs(trailingOnly=TRUE)[1]
VerificationLV(file, dir, ext)
