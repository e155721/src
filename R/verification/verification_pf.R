source("verification/VerificationPSA.R")
source("lib/load_scoring_matrix.R")

file <- "ansrate_pf"
dir <- "pairwise_pf"

for (pen in -1) {
  # Set the path of the matching rate.
  ansrate.file <- paste("../../Alignment/", file, "_", format(Sys.Date()), "_", pen, ".txt", sep = "")
  
  # Set the path of the PSA directory.
  output.dir <- paste("../../Alignment/", dir, "_", pen, "_", format(Sys.Date()), "_", pen, "/", sep = "")
  if (!dir.exists(output.dir))
    dir.create(output.dir)
  
  # Make the scoring matrix.
  s <- MakeFeatureMatrix(-Inf, pen)
  VerificationPSA(ansrate.file, output.dir, s, dist=T)
}
