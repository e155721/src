source("lib/load_data_processing.R")

OutputMSA <- function(msa_list, file_list, output_dir) {
  # Compute the MSA for each word.
  #
  # Args:
  #   msa_list: The list of MSAs.
  #   file_list: The list of words that were used for the MSA.
  #   output_dir: The path of the MSA directory.
  #
  # Returns:
  #   Nothing.

  if (dir.exists(paths = output_dir)) {
    # Do not create the directory.
  } else {
    dir.create(output_dir)
  }

  for (f in file_list) {

    msa <- msa_list[[as.integer(f["id"])]]$aln
    msa <- msa[order(msa[, 1]), ]

    # Unified the gap insertion.
    msa <- Convert(msa)

    # Outputs the MSA.
    write.table(msa, paste(output_dir, gsub("\\..*$", "", f["name"]), ".aln", sep = ""), quote = F)
  }

  return(0)
}
