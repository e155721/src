VerifAcc <- function(psa, gold)
{
  # countting the number of matched alignments
  N <- length(psa)
  match <- 0  
  for (i in 1:N) {
    psa.aln <- paste(psa[[i]]$aln, collapse = "")
    gold.aln <- paste(gold[[i]]$aln, collapse = "")
    if (psa.aln == gold.aln) {
      match <- match+1
    }
  }
  
  # calculating the matching rate
  matching.rate <- (match/N)*100
  
  return(matching.rate)
}
