source("lib/load_nwunsch.R")

MakePairwise <- function(seq_list, s) {
  # Make the PSA for all num_regs pair.
  #
  # Args:
  #   seq_list: A list of phonetic strings.
  #   s: A scoring matrix.
  #
  # Returns:
  #   The list of PSAs.
  regions <- combn(1:length(seq_list), 2)
  N <- dim(regions)[2]

  psa_list <- list()
  for (i in 1:N) {
    reg_pair <- regions[, i]
    psa_list[[i]] <- needleman_wunsch(as.matrix(seq_list[[reg_pair[1]]], drop = F),
                                      as.matrix(seq_list[[reg_pair[2]]], drop = F), s)
  }

  attributes(psa_list) <- list(word = attributes(seq_list)$word)

  return(psa_list)
}
