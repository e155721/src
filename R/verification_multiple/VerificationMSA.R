source("lib/load_data_processing.R")
source("lib/load_exec_align.R")
source("msa/ProgressiveAlignment.R")
source("msa/BestFirst.R")

VerificationMSA <- function(ansrate.file, output.dir, s, similarity=F) {
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
  
  for (file in files) {
    
    # Make the word list.
    gold.list <- MakeWordList(file["input"])  # gold alignment
    input.list <- MakeInputSeq(gold.list)     # input sequences
    
    # Computes the MSA using the BestFirst method.
    print(paste("Start:", file["name"]))
    psa.init <- ProgressiveAlignment(input.list, s, similarity)
    msa <- BestFirst(psa.init, s, similarity)
    msa <- msa$aln
    print(paste("End:", file["name"]))
    
    # Checks the accuracy of MSA.
    gold.mat <- DelGap(list2mat(gold.list))
    gold.mat <- gold.mat[order(gold.mat[, 1]), ]
    msa <- msa[order(msa[, 1]), ]
    
    # Calculates the MSA accuracy.
    dim.msa <- dim(msa)
    M <- dim.msa[1]
    N <- dim.msa[2]
    col.gold <- dim(gold.mat)[2]
    
    # Unificate the MSA.
    for (j in 1:(N - 1)) {
      if (N != col.gold) {
        break
      }
      # The columns of the MSA.
      col1.msa <- msa[, j]
      col2.msa <- msa[, (j + 1)]
      # The columns of the gold standard MSA.
      col1.gold <- gold.mat[, j]
      col2.gold <- gold.mat[, (j + 1)]

      col1 <- sum(col1.msa == col2.gold)
      col2 <- sum(col2.msa == col1.gold)
      if ((col1 == M) && (col2 == M)) {
        num1.gap <- sum(col1.msa == "-")
        num2.gap <- sum(col2.msa == "-")
        if (num1.gap <= num2.gap) {
          msa[, j]            <- col2.msa
          msa[, (j + 1)]      <- col1.msa
          gold.mat[, j]       <- col2.msa
          gold.mat[, (j + 1)] <- col1.msa
        } else {
          msa[, j]            <- col1.msa
          msa[, (j + 1)]      <- col2.msa
          gold.mat[, j]       <- col1.msa
          gold.mat[, (j + 1)] <- col2.msa
        }
      }
    }
    
    matched <- 0
    for (i in 1:M) {
      aligned <- paste(msa[i, ], collapse = " ")
      gold <- paste(gold.mat[i, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    matching.rate <- (matched / M) * 100
    accuracy.mat <- rbind(accuracy.mat, c(file[["name"]], matching.rate))
    
    # Outputs the MSA.  
    write.table(msa, paste(output.dir, gsub("\\..*$", "", file["name"]), ".aln", sep=""), quote=F)
    write.table(gold.mat, paste(output.dir, gsub("\\..*$", "", file["name"]), ".lg", sep=""), quote=F)
  }
  
  # Outputs the accuracy file.
  write.table(accuracy.mat[-1:-length(files), , drop=F], ansrate.file, quote=F)
  
  return(0)
}
