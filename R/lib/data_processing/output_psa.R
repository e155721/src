library(doMC)

source("lib/load_data_processing.R")


make_psa_mat <- function(psa) {
  # output alignments

  len_list <- lapply(psa, (function(x){
    return(dim(x$aln)[2])
  }))

  M_tmp <- length(psa)
  M <- (M_tmp * 2) + (M_tmp - 1)
  N <- max(unlist(len_list))

  psa_mat <- matrix("", M, N)
  idx <- seq(1, M, 3)

  j <- 1
  for (i in idx) {
    psa[[j]]$aln[1:2, 1] <- paste(j, ": ", psa[[j]]$aln[1:2, 1], sep = "")
    psa_len <- dim(psa[[j]]$aln)[2]
    psa_mat[i:(i + 1), 1:psa_len] <- psa[[j]]$aln
    j <- j + 1
  }

  return(psa_mat)
}


output_psa <- function(psa_list, output_dir, ext, excel=F) {
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
    word <- unlist(strsplit(word, split = "_"))
    word <- paste(word[c(1, 3)], collapse = "_")  # combine the word ID and the assumed form.

    # Get the PSA about same word.
    psa <- psa_list[[i]]

    # Unification the PSAs.
    N <- length(psa)
    for (j in 1:N) {
      psa[[j]]$aln <- Convert(psa[[j]]$aln)
    }

    psa_mat <- make_psa_mat(psa)

    if (excel) {
      write_excel_csv(as.data.frame(psa_mat), file = paste(output_dir, gsub("\\..*$", "", word), ext, sep = ""),
                      eol = "\n", na = "NA")
    } else {
      write.csv(psa_mat, file = paste(output_dir, gsub("\\..*$", "", word), ext, sep = ""),
                append = F, quote = T, sep = " ",
                eol = "\n", na = "NA", dec = ".", row.names = F,
                col.names = T, qmethod = "double", fileEncoding = "UTF-8")
    }
  }
  # END OF LOOP

  return(0)
}
