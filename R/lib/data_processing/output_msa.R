source("lib/load_data_processing.R")

OutputMSA <- function(msa_list, word_list, output_dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   word_list: The list of words that were used for the MSA.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  word_vec <- NULL
  M <- length(word_list)
  for (i in 1:M) {
  word_vec[i] <- attributes(word_list[[i]])$word
  }

  if (dir.exists(paths = output_dir)) {
    # Do not create the directory.
  } else {
    dir.create(output_dir)
  }

  i <- 1
  for (w in word_vec) {

    msa <- msa_list[[i]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa <- Convert(msa)

    # Outputs the MSA.
    write.table(msa, paste(output_dir, w, ".aln", sep = ""), quote = F)
    i <- i + 1
  }

  return(0)
}
