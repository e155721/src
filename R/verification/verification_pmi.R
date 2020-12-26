source("psa/psa_pmi.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")


file <- "ansrate_pmi"
dir <- "pairwise_pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

pmi_rlt  <- psa_pmi(word_list, cv_sep = T)
pmi_list <- pmi_rlt$pmi_list
s        <- pmi_rlt$s
psa_list <- pmi_rlt$psa_list

psa_list_gold <- lapply(word_list_gold, make_gold_psa)

# Calculate the PSAs accuracy.
VerificationPSA(psa_list, psa_list_gold, path$ansrate.file, path$output.dir)

# Output the PSAs.
output_psa(psa_list, output_dir = path$output.dir, ext = ".csv")
output_psa(psa_list_gold, output_dir = path$output.dir, ext = "_lg.csv")

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("list_psa_pmi", "score_psa_pmi", ext)
save(pmi_list, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
