Convert <- function(psa) {
  
  col <- dim(psa)[2]
  for (j in 2:col) {
    a <- psa$aln[, j]
    b <- psa$aln[, (j + 1)]
    if ((a[2] == "-") && (b[1] == "-")) {
      psa$aln[, j] <- b
      psa$aln[, (j + 1)] <- a
      psa$seq1 <- psa$aln[1, ]
      psa$seq2 <- psa$aln[2, ]
    }
  }
  
  return(psa)
}

VerifAcc <- function(psa, gold) {
  # countting the number of matched alignments
  N <- length(psa)
  match <- 0
  for (i in 1:N) {
    psa[[i]]$aln <- Convert(psa[[i]])
    psa.aln <- paste(psa[[i]]$aln, collapse = "")
    gold.aln <- paste(gold[[i]]$aln, collapse = "")
    if (psa.aln == gold.aln)
      match <- match + 1
  }
  
  # calculating the matching rate
  matching.rate <- (match / N) * 100
  
  return(matching.rate)
}
