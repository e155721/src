library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")

PSAforEachWord <- function(list.words, s, dist = F) {
  # Compute the PSA for each word.
  # Args:
  #   s: The scoring matrix.
  #   dist: The PSA will be using a distance or not.
  #
  # Returns:
  #   The list of PSA for each word.
  
  # START OF LOOP
  psa.list <- foreach (f = list.words) %dopar% {
    
    # Make the word list.
    input.list <- MakeInputSeq(MakeWordList(f[["input"]]))
    
    # Compute the PSA for each region.
    psa <- MakePairwise(input.list, s, select.min=dist)
    
    # Unification the PSAs.
    N <- length(psa)
    for (i in 1:N) {
      psa[[i]] <- Convert(psa[[i]])
    }
    
    return(psa)
  }
  
  return(psa.list)
}
