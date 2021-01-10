library(doMC)

source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")


verify_psa <- function(psa_list, psa_list_gold, ansrate_file, output_dir) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate_file: The path of the matching rate file.
  #   output_dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.

  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

  M <- length(psa_list)

  # START OF LOOP
  foreach.rlt <- foreach(i = 1:M) %dopar% {

    word <- attributes(psa_list[[i]])$word

    # Get the PSA about same word.
    psa      <- psa_list[[i]]
    psa_gold <- psa_list_gold[[i]]

    # Unification the PSAs.
    N <- length(psa_gold)
    for (j in 1:N) {
      psa[[j]]$aln      <- Convert(psa[[j]]$aln)
      psa_gold[[j]]$aln <- Convert(psa_gold[[j]]$aln)
    }

    # Count the number of matched alignments.
    match <- 0
    for (i in 1:N) {
      psa_tmp <- paste(psa[[i]]$aln, collapse = "")
      gold_tmp <- paste(psa_gold[[i]]$aln, collapse = "")
      if (psa_tmp == gold_tmp)
        match <- match + 1
    }

    # Calculate the matching rate.
    matching.rate <- (match / N) * 100

    OutputAlignmentCheck(word, output_dir, ".check", psa, psa_gold)  # writing the match or mismatch

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
