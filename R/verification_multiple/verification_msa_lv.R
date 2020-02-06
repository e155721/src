source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")
source("verification_multiple/VerificationMSA.R")
source("parallel_config.R")

ansrate <- "ansrate_msa_lv"
multiple <- "multiple_lv"

# matchingrate path
ansrate.file <- paste("../../Alignment/", ansrate, "_", format(Sys.Date()), ".txt", sep = "")

# result path
output.dir <- paste("../../Alignment/", multiple, "_", format(Sys.Date()), sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

s <- MakeEditDistance(Inf)
VerificationMSA(ansrate.file, output.dir, s, similarity=F)
