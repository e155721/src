Convert <- function(psa) {
  
  col <- dim(psa$aln)[2] - 1
  for (j in 2:col) {
    a <- psa$aln[, j]
    b <- psa$aln[, (j + 1)]
    if ((a[1] == "-") && (b[2] == "-")) {
      psa$aln[, j] <- b
      psa$aln[, (j + 1)] <- a
      psa$seq1 <- psa$aln[1, , drop=F]
      psa$seq2 <- psa$aln[2, , drop=F]
    }
  }
  
  return(psa)
}

VerifAcc <- function(psa, gold) {
  # countting the number of matched alignments
  N <- length(psa)
  match <- 0
  for (i in 1:N) {
    psa.aln <- paste(psa[[i]]$aln, collapse = "")
    gold.aln <- paste(gold[[i]]$aln, collapse = "")
    if (psa.aln == gold.aln)
      match <- match + 1
  }
  
  # calculating the matching rate
  matching.rate <- (match / N) * 100
  
  return(matching.rate)
}
