source("lib/load_data_processing.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")

VerificationPSA <- function(ansrate.file, output.dir, s, dist=T) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.
  
  # Get the all of files path.
  file.list <- GetPathList()
  
  # START OF LOOP
  foreach.rlt <- foreach (f = file.list) %dopar% {
    
    # Make the word list.
    gold.list <- MakeWordList(f["input"])
    input.list <- MakeInputSeq(gold.list)
    
    # Make the gold standard alignments.
    gold.aln <- MakeGoldStandard(gold.list)
    
    # Compute the PSA for each region.
    psa.aln <- MakePairwise(input.list, s, select.min=dist)
    
    # Unification the PSAs.
    N <- length(gold.aln)
    for (i in 1:N) {
      gold.aln[[i]] <- Convert(gold.aln[[i]])
      psa.aln[[i]] <- Convert(psa.aln[[i]])
    }
    
    # Output the results.
    matching.rate <- VerifAcc(psa.aln, gold.aln)                              # calculating the matching rate
    OutputAlignment(f["name"], output.dir, ".lg", gold.aln)                   # writing the gold standard
    OutputAlignment(f["name"], output.dir, ".aln", psa.aln)                   # writing the PSA
    OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)  # writing the match or mismatch
    
    # Returns the matching rate to the list of foreach.
    c(f["name"], matching.rate)
  }
  # END OF LOOP
  
  # Output the matching rate.
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop=F]
  write.table(matching.rate.mat, ansrate.file, quote = F)
  
  return(0)
}
