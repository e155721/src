source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")

MSAforEachWord <- function(list.words, s, similarity=F) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   The list of MSA for each word.
  
  # Get the all of files path.
  list.words <- GetPathList()
  accuracy.mat <- matrix(NA, length(list.words), 2)
  msa.list <- list()
  
  i <- 1
  for (w in list.words) {
    
    # Make the word list.
    gold.list <- MakeWordList(w["input"])  # gold alignment
    psa.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Computes the MSA using the BestFirst method.
    print(paste("Start:", w["name"]))
    psa.init <- ProgressiveAlignment(psa.list, s, similarity)
    msa.list[[i]] <- list()
    msa.list[[i]] <- BestFirst(psa.init, s, similarity)
    i <- i + 1
    print(paste("End:", w["name"]))
    
  }
  
  return(msa.list)
}
