source("msa/msa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("verification_multiple/verification_msa.R")
source("parallel_config.R")

source("plot_graphs.R")
source("dist_psa.R")


ansrate <- "ansrate_msa_lv"
multiple <- "multiple_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Get the all of files path.
file_list <- GetPathList()
word_list <- make_word_list(file_list)

msa_list <- msa_lv(word_list)

verification_msa(msa_list, file_list, path$ansrate.file, path$output.dir)

Plot(msa_list = msa_list, output_dir = path$output.dir, method = "ld", s = MakeEditDistance(Inf))

make_region_dist(file_list = file_list, output_dir = path$output.dir, method = "ld", s = MakeEditDistance(Inf))
