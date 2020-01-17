source("lib/load_nwunsch.R")

MakePairwise <- function(seq.list, s, select.min=F) {
  # Make the PSA for all num.regs pair.
  #
  # Args:
  #   seq.list: The list of phonetic strings.
  #   s: The scoring matrix.
  #   select.min: Whether the optimal alignment is maximized or minimized.
  #
  # Returns:
  #   The list of PSAs.
  num.regs <- length(seq.list)
  combs.regs <- combn(1:num.regs, 2)
  N <- dim(combs.regs)[2]
  
  psa.list <- list()
  for (i in 1:N) {
    pair.regs <- combs.regs[, i]
    psa.list[[i]] <- NeedlemanWunsch(as.matrix(seq.list[[pair.regs[1]]], drop = F),
                                     as.matrix(seq.list[[pair.regs[2]]], drop = F), s, select.min)
  }
  
  return(psa.list)
}
