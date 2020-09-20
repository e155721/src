source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


input.dir  <- commandArgs(trailingOnly = TRUE)[1]
output.dir <- commandArgs(trailingOnly = TRUE)[2]

input.dir  <- paste(input.dir, "/", sep = "")
output.dir <- paste(output.dir, "/", sep = "")

# Execute the PSA for each word.
file_list <- GetPathList(input.dir)
word_list <- make_word_list(file_list)

s <- MakeEditDistance(Inf)
psa.list <- PSAforEachWord(word_list, s, dist = T)
OutputPSA(psa.list, file_list, output.dir)
