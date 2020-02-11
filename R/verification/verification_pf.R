source("psa/psa_for_all_words.R")
source("verification/verification_psa.R")
source("lib/load_scoring_matrix.R")
source("parallel_config.R")

file <- "ansrate_pf"
dir <- "pairwise_pf"

for (pen in -1) {
  # Set the path of the matching rate.
  ansrate.file <- paste("../../Alignment/", file, "_", pen, "_", format(Sys.Date()), ".txt", sep = "")
  
  # Set the path of the PSA directory.
  output.dir <- paste("../../Alignment/", dir, "_", pen, "_", format(Sys.Date()), "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # Make the scoring matrix.
  s <- MakeFeatureMatrix(-Inf, pen)
  psa.list <- PSAforAllWrods(s, dist=F)
  VerificationPSA(psa.list, ansrate.file, output.dir)
}
