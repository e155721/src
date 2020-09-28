source("psa/psa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification/verification_psa.R")
source("parallel_config.R")


file <- "ansrate_lv"
dir <- "pairwise_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

file_list <- GetPathList()
word_list <- make_word_list(file_list)

psa_list <- psa_lv(word_list)

VerificationPSA(psa_list, file_list, path$ansrate.file, path$output.dir)
