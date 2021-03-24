source("lib/load_exec_align.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_phylo.R")
source("parallel_config.R")


output_dir_base <- commandArgs(trailingOnly = TRUE)[1]

method <- "ld"
p_vec <- 1:5

for (p in p_vec) {

  print(paste("Gap:", p))

  ext_name <- paste(p, ".0", sep = "")
  ext_name <- paste("_", ext_name, sep = "")

  output_dir <- paste(output_dir_base, "/", "psa_", method, ext_name, "/", sep = "")
  if (!dir.exists(output_dir))
    dir.create(output_dir)

  acc_file <- paste(output_dir, "/", "acc_psa_", method, ext_name, ".txt", sep = "")

  word_list      <- make_word_list("../../Alignment/org_data/input.csv")
  word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")
  psa_list_gold <- lapply(word_list_gold, make_gold_psa)

  s <- MakeEditDistance(Inf, p)
  psa_list <- PSAforEachWord(word_list, s)

  output_dir_aln <- paste(output_dir, "/alignment/", sep = "")

  # Calculate the PSAs accuracy.
  verify_psa(psa_list, psa_list_gold, acc_file, output_dir_aln)

  # Output the PSAs.
  output_psa(psa_list, output_dir = output_dir_aln, ext = ".csv")
  output_psa(psa_list_gold, output_dir = output_dir_aln, ext = "_lg.csv")
}
