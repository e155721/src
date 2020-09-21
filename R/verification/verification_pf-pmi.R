source("psa/psa_pf-pmi.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification/verification_psa.R")


file <- "ansrate_pf-pmi"
dir <- "pairwise_pf-pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(file, dir, ext)

file_list <- GetPathList()
word_list <- make_word_list(file_list)

pmi_rlt  <- psa_pf_pmi(word_list)
pmi_mat  <- pmi_rlt$pmi_mat
s        <- pmi_rlt$s
psa_list <- pmi_rlt$psa_list

# Execute the PSA for each word.
VerificationPSA(psa_list, file_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("matrix_psa_pf-pmi", "score_psa_pf-pmi", ext)
save(pmi_mat, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
