source("psa/psa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification/verification_psa.R")
source("parallel_config.R")


file <- "ansrate_lv"
dir <- "pairwise_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

word_list <- make_word_list("../../Alignment/org_data/input.csv")
gold_list <- make_word_list("../../Alignment/org_data/gold.csv")

psa_list <- psa_lv(word_list)

VerificationPSA(psa_list, gold_list, path$ansrate.file, path$output.dir)
