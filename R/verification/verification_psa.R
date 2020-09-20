library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")


VerificationPSA <- function(psa_list, file_list, ansrate_file, output_dir) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate_file: The path of the matching rate file.
  #   output_dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.

  N <- length(file_list)

  # START OF LOOP
  foreach.rlt <- foreach(f = file_list) %dopar% {

    gold.list <- MakeWordList(f[["input"]])  # making the list of gold standard sequences
    gold.aln  <- MakeGoldStandard(gold.list)  # making the gold standard alignments

    # Get the PSA about same word.
    id <- as.numeric(f[["id"]])
    psa <- psa_list[[id]]

    # Unification the PSAs.
    N <- length(gold.aln)
    for (i in 1:N) {
      psa[[i]]      <- Convert(psa[[i]])
      gold.aln[[i]] <- Convert(gold.aln[[i]])
    }

    # Output the results.
    matching.rate <- VerifAcc(psa, gold.aln)  # calculating the matching rate
    OutputAlignment(f[["name"]], output_dir, ".lg", gold.aln)  # writing the gold standard
    OutputAlignment(f[["name"]], output_dir, ".aln", psa)  # writing the PSA
    OutputAlignmentCheck(f[["name"]], output_dir, ".check", psa, gold.aln)  # writing the match or mismatch

    # Returns the matching rate to the list of foreach.
    c(f[["name"]], matching.rate)
  }
  # END OF LOOP

  # Output the matching rate.
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop = F]
  write.table(matching.rate.mat, ansrate_file, quote = F)

  return(0)
}
