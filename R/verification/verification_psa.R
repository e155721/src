library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")


VerificationPSA <- function(psa_list, gold_list, ansrate_file, output_dir) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate_file: The path of the matching rate file.
  #   output_dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.

  M <- length(gold_list)

  # START OF LOOP
  foreach.rlt <- foreach(i = 1:M) %dopar% {

    word <- unlist(attributes(gold_list[[i]]))

    gold.aln  <- MakeGoldStandard(gold_list[[i]])  # making the gold standard alignments

    # Get the PSA about same word.
    psa <- psa_list[[i]]

    # Unification the PSAs.
    N <- length(gold.aln)
    for (j in 1:N) {
      psa[[j]]$aln      <- Convert(psa[[j]]$aln)
      gold.aln[[j]]$aln <- Convert(gold.aln[[j]]$aln)
    }

    # Output the results.
    matching.rate <- VerifAcc(psa, gold.aln)  # calculating the matching rate
    OutputAlignment(word, output_dir, ".lg", gold.aln)  # writing the gold standard
    OutputAlignment(word, output_dir, ".aln", psa)  # writing the PSA
    OutputAlignmentCheck(word, output_dir, ".check", psa, gold.aln)  # writing the match or mismatch

    # Returns the matching rate to the list of foreach.
    c(word, matching.rate)
  }
  # END OF LOOP

  # Output the matching rate.
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop = F]
  write.table(matching.rate.mat, ansrate_file, quote = F)

  return(0)
}
