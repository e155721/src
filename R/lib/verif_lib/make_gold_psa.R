source("lib/load_data_processing.R")

make_gold_psa <- function(x) {
  # x: The list of gold standard sequences.

  regions <- combn(1:length(x), 2)
  N <- dim(regions)[2]

  psa      <- list()
  psa_list <- list()
  for (j in 1:N) {
    i <- regions[, j]
    x_psa <- DelGap(rbind(x[[i[1]]], x[[i[2]]]))
    psa$seq1 <- x_psa[1, , drop = F]
    psa$seq2 <- x_psa[2, , drop = F]
    psa$aln <- x_psa
    psa_list[[j]] <- psa
  }

  attributes(psa_list) <- list(word = attributes(x)$word)

  return(psa_list)
}
