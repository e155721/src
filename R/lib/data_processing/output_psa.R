source("lib/load_data_processing.R")

OutputPSA <- function(psa_list, word_list, output.dir) {
  # Compute the PSA for each word.
  # Args:
  #   ansrate.file: The path of the matching rate file.
  #   output.dir:   The path of the PSA directory.
  #   s:            The scoring matrix.
  # Returns:
  #   Nothing.

  # Get the all of files path.
  #word_list <- GetPathList()
  N <- length(word_list)

  word_vec <- NULL
  for (i in 1:N) {
    word_vec[i] <- attributes(word_list[[i]])$word
  }

  if (dir.exists(paths = output.dir)) {
    # Do not create the directory.
  } else {
    dir.create(output.dir)
  }

  # START OF LOOP
  foreach.rlt <- foreach(i = 1:N) %dopar% {

    # Get the PSA about same word.
    psa <- psa_list[[i]]

    # Unification the PSAs.
    N <- length(psa)
    for (i in 1:N) {
      psa[[i]]$aln <- Convert(psa[[i]]$aln)
    }

    # Output the results.
    for (i in 1:N) {
      # by The Needleman-Wunsch
      sink(paste(output.dir, word_vec[i], ".aln", sep = ""), append = T)
      cat(paste(i, " "))
      print(paste(psa[[i]]$seq1, collapse = " "), quote = F)
      cat(paste(i + 1, " "))
      print(paste(psa[[i]]$seq2, collapse = " "), quote = F)
      cat("\n")
      sink()
    }

  }
  # END OF LOOP

  return(0)
}
