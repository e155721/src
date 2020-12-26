make_gold_msa <- function(x) {
  # x: The list of a gold sequences.
  x_msa <- list()
  x_msa$aln <- DelGap(list2mat(x))
  attributes(x_msa) <- list(names = names(x_msa), word = attributes(x)$word)
  return(x_msa)
}