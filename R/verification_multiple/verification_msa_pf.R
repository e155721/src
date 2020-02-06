source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("verification_multiple/VerificationMSA.R")
source("parallel_config.R")

ansrate <- "ansrate_msa_pf"
multiple <- "multiple_pf"

for (pen in (-1)) {
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/", ansrate, "_", format(Sys.Date()), "_", pen, ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/", multiple, "_", format(Sys.Date()), "_", pen, "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  s <- MakeFeatureMatrix(-Inf, pen)
  VerificationMSA(ansrate.file, output.dir, s, similarity=T)
}