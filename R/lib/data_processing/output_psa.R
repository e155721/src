source("lib/load_data_processing.R")

OutputPSA <- function(psa_list, file.list, output.dir) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  #
  # Returns:
  #   Nothing.

  # Get the all of files path.
  #file.list <- GetPathList()
  N <- length(file.list)

  if (dir.exists(paths = output.dir)) {
    # Do not create the directory.
  } else {
    dir.create(output.dir)
  }

  # START OF LOOP
  foreach.rlt <- foreach (f = file.list) %dopar% {

    # Get the PSA about same word.
    id <- as.numeric(f[["id"]])
    psa <- psa_list[[id]]

    # Unification the PSAs.
    N <- length(psa)
    for (i in 1:N) {
      psa[[i]]$aln <- Convert(psa[[i]]$aln)
    }

    # Output the results.
    for (i in 1:N) {
      # by The Needleman-Wunsch
      sink(paste(output.dir, gsub("\\..*$", "", f["name"]), ".aln", sep = ""), append = T)
      cat(paste(i, " "))
      print(paste(psa[[i]]$seq1, collapse = " "), quote = F)
      cat(paste(i+1, " "))
      print(paste(psa[[i]]$seq2, collapse = " "), quote = F)
      cat("\n")
      sink()
    }

  }
  # END OF LOOP

  return(0)
}
