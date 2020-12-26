source("msa/msa_lv.R")
source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("parallel_config.R")


ansrate <- "ansrate_msa_lv"
multiple <- "multiple_lv"
ext <- commandArgs(trailingOnly = TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Get the all of files path.
word_list      <- make_word_list("../../Alignment/org_data/input.csv")
word_list_gold <- make_word_list("../../Alignment/org_data/gold.csv")

msa_list      <- msa_lv(word_list)
msa_list_gold <- lapply(word_list_gold, (function(x){
  x_tmp             <- DelGap(list2mat(x))
  attributes(x_tmp) <- list(dim = dim(x_tmp), word = attributes(x)$word)
  y     <- list()
  y$aln <- x_tmp
  return(y)
}))

# Calculate the MSAs accuracy.
verification_msa(msa_list, msa_list_gold, path$ansrate.file, path$output.dir)

# Output the MSAs.
output_msa(msa_list, path$output.dir, ".csv")
output_msa(msa_list_gold, path$output.dir, "_lg.csv")
