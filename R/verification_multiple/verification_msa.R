source("lib/load_data_processing.R")

verification_msa <- function(msa_list, gold_list, ansrate_file, output_dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   gold_list: The list of words that were used for the MSA.
  #   ansrate_file: The path of the matching rate file.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  acc_mat <- matrix(NA, length(gold_list), 2)

  M <- length(gold_list)

  for (i in 1:M) {

    word <- attributes(gold_list[[i]])

    # Checks the accuracy of MSA.
    gold_mat <- DelGap(list2mat(gold_list[[i]]))
    gold_mat <- gold_mat[order(gold_mat[, 1]), ]
    msa <- msa_list[[i]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa       <- Convert(msa)
    gold_mat  <- Convert(gold_mat)

    # Calculates the MSA accuracy.
    M <- dim(msa)[1]
    matched <- 0
    for (j in 1:M) {
      aligned <- paste(msa[j, ], collapse = " ")
      gold <- paste(gold_mat[j, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    acc <- (matched / M) * 100
    acc_mat <- rbind(acc_mat, c(word, acc))

    # Outputs the MSA.
    write.table(msa, paste(output_dir, gsub("\\..*$", "", word), ".aln", sep = ""), quote = F)
    write.table(gold_mat, paste(output_dir, gsub("\\..*$", "", word), ".lg", sep = ""), quote = F)
  }

  # Outputs the accuracy file.
  write.table(acc_mat[-1:-length(gold_list), , drop = F], ansrate_file, quote = F)

  return(0)
}
