source("msa/msa_pmi.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_pmi"
multiple <- "multiple_pmi"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

file_list <- GetPathList()
word_list <- make_word_list(file_list)

pmi_rlt  <- msa_pmi(word_list, cv_sep = F)
pmi_list  <- pmi_rlt$pmi_list
s        <- pmi_rlt$s
msa_list <- pmi_rlt$msa_list

# Calculate the accuracy of the MSAs.
verification_msa(msa_list, file_list, path$ansrate.file, path$output.dir)

# Save the matrix of the PMIs and the scoring matrix.
rdata_path <- MakeMatPath("list_msa_pmi", "score_msa_pmi", ext)
save(pmi_list, file = rdata_path$rdata1)
save(s, file = rdata_path$rdata2)
