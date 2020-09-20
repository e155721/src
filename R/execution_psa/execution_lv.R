source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

# Execute the PSA for each word.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)

s <- MakeEditDistance(Inf)
psa_list <- PSAforEachWord(word_list, s, dist = T)
OutputPSA(psa_list, file_list, output_dir)
