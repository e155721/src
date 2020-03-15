source("lib/load_scoring_matrix.R")
source("lib/load_verif_lib.R")
source("psa/psa_for_all_words.R")
source("verification/verification_psa.R")
source("parallel_config.R")

file <- "ansrate_lv"
dir <- "pairwise_lv"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(file, dir, ext)

# Execute the PSA for each word.
s <- MakeEditDistance(Inf)
psa.list <- PSAforAllWrods(s, dist=T)
VerificationPSA(psa.list, path$ansrate.file, path$output.dir)
