source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")

input.dir  <- commandArgs(trailingOnly = TRUE)[1]
output.dir <- commandArgs(trailingOnly = TRUE)[2]
pen        <- commandArgs(trailingOnly = TRUE)[3]

if (is.na(pen)) {
  pen <- -1
} else {
  pen <- as.numeric(pen)
}

input.dir  <- paste(input.dir, "/", sep = "")
output.dir <- paste(output.dir, "/", sep = "")

file_list <- GetPathList(input.dir)
word_list <- make_word_list(file_list)
s <- MakeFeatureMatrix(-Inf, pen)
psa.list <- PSAforEachWord(word_list, s, dist = F)
OutputPSA(psa.list, file_list, output.dir)
