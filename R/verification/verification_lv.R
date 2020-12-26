source("psa/psa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")


file <- "ansrate_lv"
dir <- "pairwise_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

psa_list      <- psa_lv(word_list)
psa_list_gold <- lapply(word_list_gold, make_gold_psa)

# Calculate the PSAs accuracy.
VerificationPSA(psa_list, psa_list_gold, path$ansrate.file, path$output.dir)

# Output the PSAs.
output_psa(psa_list, output_dir = path$output.dir, ext = ".csv")
output_psa(psa_list_gold, output_dir = path$output.dir, ext = "_lg.csv")
