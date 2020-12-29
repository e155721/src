source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method     <- commandArgs(trailingOnly = TRUE)[1]
input_file <- commandArgs(trailingOnly = TRUE)[2]
output_dir <- commandArgs(trailingOnly = TRUE)[3]
cv_sep     <- commandArgs(trailingOnly = TRUE)[4]

output_dir <- paste(output_dir, "/", "msa_", method, "/", sep = "")
if (!dir.exists(output_dir))
  dir.create(output_dir)

# Execute the MSA.
word_list <- make_word_list(input_file)
msa_rlt   <- execute_msa(method, word_list, output_dir, cv_sep)

if (method == "ld") {
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list
} else {
  pmi_list <- msa_rlt$pmi_list
  s        <- msa_rlt$s
  msa_list <- msa_rlt$msa_list

  # Save the matrix of the PMIs and the scoring matrix.
  save(pmi_list, file = paste(output_dir, "/", "list_msa_", method, ".RData", sep = ""))
  save(s, file = paste(output_dir, "/", "score_msa_", method, ".RData", sep = ""))
}

output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

# Output the MSAs.
output_msa(msa_list, output_dir_aln, ext = ".csv")

# Plot the phylogenetic trees and the networks.
psa_list <- ChangeListMSA2PSA(msa_list, s)
Plot(psa_list, output_dir, method, s)

# Calculate the regional distance matrix.
make_region_dist(word_list, method, s, output_dir)
