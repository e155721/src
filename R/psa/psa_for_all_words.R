library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")

PSAforAllWrods <- function(s, dist) {
  # Get the all of files path.
  file.list <- GetPathList()
  
  # START OF LOOP
  psa.list <- foreach (f = file.list) %dopar% {
    
    # Make the word list.
    input.list <- MakeInputSeq(MakeWordList(f[["input"]]))
    
    # Compute the PSA for each region.
    psa <- MakePairwise(input.list, s, select.min=dist)
    
    return(psa)
  }
  
  return(psa.list)
}
