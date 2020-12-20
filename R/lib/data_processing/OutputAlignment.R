OutputAlignment <- function(f, output.path, ext, psa) {
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

  write.csv(psa_mat, file = paste(output.path, gsub("\\..*$", "", f), ext, sep = ""),
            append = F, quote = T, sep = " ",
            eol = "\n", na = "NA", dec = ".", row.names = F,
            col.names = T, qmethod = "double", fileEncoding = "UTF-8")

  return(0)
}
