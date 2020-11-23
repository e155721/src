source("msa/msa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_lv"
multiple <- "multiple_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Get the all of files path.
word_list <- make_word_list("../../Alignment/org_data/input.csv")
gold_list <- make_word_list("../../Alignment/org_data/gold.csv")

msa_list <- msa_lv(word_list)

verification_msa(msa_list, gold_list, path$ansrate.file, path$output.dir)
