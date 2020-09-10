source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")

MSAforEachWord <- function(word_list, s, similarity=F) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   The list of MSA for each word.

  msa_list <- lapply(word_list, (function(seq_list, s, similarity){
    # Computes the MSA using the BestFirst method.
    msa_init <- ProgressiveAlignment(seq_list, s, similarity)
    msa      <- BestFirst(msa_init, s, similarity)
    return(msa)
  }), s, similarity)

  return(msa_list)
}
