source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("parallel_config.R")


input_dir  <- commandArgs(trailingOnly = TRUE)[1]
output_dir <- commandArgs(trailingOnly = TRUE)[2]
pen        <- commandArgs(trailingOnly = TRUE)[3]

if (is.na(pen)) {
  pen <- -1
} else {
  pen <- as.numeric(pen)
}

input_dir  <- paste(input_dir, "/", sep = "")
output_dir <- paste(output_dir, "/", sep = "")

# Make the list of the MSAs.
file_list <- GetPathList(input_dir)
word_list <- make_word_list(file_list)
s <- MakeFeatureMatrix(-Inf, pen)
msa_list <- MSAforEachWord(word_list, s, similarity = T)
OutputMSA(msa_list, file_list, output_dir)
