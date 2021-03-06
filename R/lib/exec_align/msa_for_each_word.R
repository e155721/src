source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/msa/ProgressiveAlignment.R")
source("lib/msa/BestFirst.R")

MSAforEachWord <- function(word_list, s) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   The list of MSA for each word.

  msa_list <- foreach(seq_list = word_list) %dopar% {
    ProgressiveAlignment(seq_list, s)
  }

  msa_list <- lapply(msa_list, (function(msa_init, s){
    # Computes the MSA using the BestFirst method.
    msa <- BestFirst(msa_init, s)
    return(msa)
  }), s)

  return(msa_list)
}
