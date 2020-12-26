source("lib/load_data_processing.R")

verification_msa <- function(msa_list, msa_list_gold, ansrate_file, output_dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   msa_list_gold: The list of words that were used for the MSA.
  #   ansrate_file: The path of the matching rate file.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

  acc_mat <- matrix(NA, length(msa_list), 2)

  M <- length(msa_list_gold)

  for (i in 1:M) {

    word <- attributes(msa_list[[i]])$word

    # Checks the accuracy of MSA.
    msa_gold <- msa_list_gold[[i]]$aln
    msa_gold <- msa_gold[order(msa_gold[, 1]), ]
    msa <- msa_list[[i]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa       <- Convert(msa)
    msa_gold  <- Convert(msa_gold)

    # Calculates the MSA accuracy.
    M <- dim(msa)[1]
    matched <- 0
    for (j in 1:M) {
      aligned <- paste(msa[j, ], collapse = " ")
      gold <- paste(msa_gold[j, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    acc <- (matched / M) * 100
    acc_mat <- rbind(acc_mat, c(word, acc))

  }

  # Outputs the accuracy file.
  write.table(acc_mat[-1:-length(msa_list_gold), , drop = F], ansrate_file, quote = F)

  return(0)
}
