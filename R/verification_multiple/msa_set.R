source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")

MakeListMSA <- function(s, similarity=F) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.
  
  # Get the all of files path.
  files <- GetPathList()
  accuracy.mat <- matrix(NA, length(files), 2)
  msa.list <- list()
  
  i <- 1
  for (file in files) {
    
    # Make the word list.
    gold.list <- MakeWordList(file["input"])  # gold alignment
    psa.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Computes the MSA using the BestFirst method.
    print(paste("Start:", file["name"]))
    psa.init <- ProgressiveAlignment(psa.list, s, similarity)
    msa.list[[i]] <- list()
    msa.list[[i]] <- BestFirst(psa.init, s, similarity)
    i <- i + 1
    print(paste("End:", file["name"]))
    
  }
  
  return(msa.list)
}

VerificationMSA <- function(ansrate.file, output.dir, msa.list) {
  # Compute the MSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the MSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.
  
  # Get the all of files path.
  files <- GetPathList()
  accuracy.mat <- matrix(NA, length(files), 2)
  
  m <- 1  
  for (file in files) {
    msa <- msa.list[[m]]$aln
    m <- m + 1
    
    # Make the word list.
    gold.list <- MakeWordList(file["input"])  # gold alignment
    input.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Checks the accuracy of MSA.
    gold.mat <- DelGap(list2mat(gold.list))
    gold.mat <- gold.mat[order(gold.mat[, 1]), ]
    msa <- msa[order(msa[, 1]), ]
    
    # Calculates the MSA accuracy.
    N <- dim(msa)[1]
    matched <- 0
    for (i in 1:N) {
      aligned <- paste(msa[i, ], collapse = " ")
      gold <- paste(gold.mat[i, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    matching.rate <- (matched / N) * 100
    accuracy.mat <- rbind(accuracy.mat, c(file[["name"]], matching.rate))
    
    # Outputs the MSA.  
    write.table(msa, paste(output.dir, gsub("\\..*$", "", file["name"]), ".aln", sep=""), quote=F)
    write.table(gold.mat, paste(output.dir, gsub("\\..*$", "", file["name"]), ".lg", sep=""), quote=F)
  }
  
  # Outputs the accuracy file.
  write.table(accuracy.mat[-1:-length(files), , drop=F], ansrate.file, quote=F)
  
  return(0)
}
