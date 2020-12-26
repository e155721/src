source("lib/load_nwunsch.R")

MakePairwise <- function(seq.list, s, select_min=F) {
  # Make the PSA for all num.regs pair.
  #
  # Args:
  #   seq.list: The list of phonetic strings.
  #   s: The scoring matrix.
  #   select_min: Whether the optimal alignment is maximized or minimized.
  #
  # Returns:
  #   The list of PSAs.
  num.regs <- length(seq.list)
  combs.regs <- combn(1:num.regs, 2)
  N <- dim(combs.regs)[2]

  psa_list <- list()
  for (i in 1:N) {
    pair.regs <- combs.regs[, i]
    psa_list[[i]] <- needleman_wunsch(as.matrix(seq.list[[pair.regs[1]]], drop = F),
                                      as.matrix(seq.list[[pair.regs[2]]], drop = F), s, select_min)
  }

  attributes(psa_list) <- list(word = attributes(seq.list)$word)

  return(psa_list)
}
