source("lib/exec_align/make_pairwise.R")

PSAforAllWords <- function(list.words, s) {
  # Make the PSA for all words.
  #
  # Args:
  #   list.words: The list of the words.
  #   s: The scoring matrix.
  # Returns:
  #   The ist of PSA.
  psa.list <- foreach(w = list.words) %dopar% {
    seq.list <- MakeInputSeq(MakeWordList(w["input"]))
    MakePairwise(seq.list, s, select.min=T)
  }
  
  return(psa.list)
}
