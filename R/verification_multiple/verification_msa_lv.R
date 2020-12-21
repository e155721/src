source("msa/msa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_phylo.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_lv"
multiple <- "multiple_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Get the all of files path.
file_list <- GetPathList()
word_list <- make_word_list(file_list)

# Make the MSAs for each word.
msa_list <- msa_lv(word_list)

#Verification for the MSAs accuracy.
verification_msa(msa_list, file_list, path$ansrate.file, path$output.dir)

# Plot the phylogenetic trees and the networks.
Plot(msa_list = msa_list, output_dir = path$output.dir, method = "ld", s = MakeEditDistance(Inf))

# Calculate the regional distance matrix.
make_region_dist(output_dir = path$output.dir, method = "ld", s = MakeEditDistance(Inf))
