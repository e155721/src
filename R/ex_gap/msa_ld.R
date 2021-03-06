source("lib/load_msa.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_phylo.R")
source("parallel_config.R")


method          <- commandArgs(trailingOnly = TRUE)[1]
input_dir       <- commandArgs(trailingOnly = TRUE)[2]
output_dir_base <- commandArgs(trailingOnly = TRUE)[3]
gap_max         <- commandArgs(trailingOnly = TRUE)[4]

if (is.na(gap_max)) {
  p_vec <- 1:5
} else {
  p_vec <- 1:gap_max
}

for (p in p_vec) {

  print(paste("Gap:", p))

  ext_name <- paste(p, ".0", sep = "")
  ext_name <- paste("_", ext_name, sep = "")

  output_dir <- paste(output_dir_base, "/", "msa_", method, ext_name, "/", sep = "")
  if (!dir.exists(output_dir))
    dir.create(output_dir, recursive = T)

  acc_file <- paste(output_dir, "/", "acc_msa_", method, ext_name, ".txt", sep = "")

  word_list      <- make_word_list("../../Alignment/org_data/input.csv")
  word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")
  msa_list_gold <- lapply(word_list_gold, make_gold_msa)

  if (method == "ld2") {
    s <- MakeEditDistance2(Inf)  # using features
  } else {
    s <- MakeEditDistance(Inf)
  }
  msa_list <- MSAforEachWord(word_list, s)

  output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

  # Calculate the msas accuracy.
  verification_msa(msa_list, msa_list_gold, acc_file, output_dir_aln)

  # Output the msas.
  output_msa(msa_list, output_dir = output_dir_aln, ext = ".csv")
  output_msa(msa_list_gold, output_dir = output_dir_aln, ext = "_lg.csv")
}
