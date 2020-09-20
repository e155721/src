source("lib/load_data_processing.R")

verification_msa <- function(msa_list, file_list, ansrate_file, output_dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   file_list: The list of words that were used for the MSA.
  #   ansrate_file: The path of the matching rate file.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  acc_mat <- matrix(NA, length(file_list), 2)

  for (f in file_list) {

    # Make the word list.
    gold_list <- MakeWordList(f["input"])  # gold alignment

    # Checks the accuracy of MSA.
    gold_mat <- DelGap(list2mat(gold_list))
    gold_mat <- gold_mat[order(gold_mat[, 1]), ]
    msa <- msa_list[[as.integer(f["id"])]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa       <- Convert(msa)
    gold_mat  <- Convert(gold_mat)

    # Calculates the MSA accuracy.
    M <- dim(msa)[1]
    matched <- 0
    for (i in 1:M) {
      aligned <- paste(msa[i, ], collapse = " ")
      gold <- paste(gold_mat[i, ], collapse = " ")
      if (aligned == gold)
        matched <- matched + 1
    }
    acc <- (matched / M) * 100
    acc_mat <- rbind(acc_mat, c(f[["name"]], acc))

    # Outputs the MSA.
    write.table(msa, paste(output_dir, gsub("\\..*$", "", f["name"]), ".aln", sep = ""), quote = F)
    write.table(gold_mat, paste(output_dir, gsub("\\..*$", "", f["name"]), ".lg", sep = ""), quote = F)
  }

  # Outputs the accuracy file.
  write.table(acc_mat[-1:-length(file_list), , drop = F], ansrate_file, quote = F)

  return(0)
}
