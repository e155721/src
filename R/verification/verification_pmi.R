source("psa/psa_pmi.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification/verification_psa.R")
source("parallel_config.R")


file <- "ansrate_pmi"
dir <- "pairwise_pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

file_list <- GetPathList()
word_list <- make_word_list(file_list)

pmi_rlt  <- psa_pmi(word_list, cv_sep = F)
pmi_list  <- pmi_rlt$pmi_list
s        <- pmi_rlt$s
psa_list <- pmi_rlt$psa_list

# Execute the PSA for each word.
VerificationPSA(psa_list, file_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("list_psa_pmi", "score_psa_pmi", ext)
save(pmi_list, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
