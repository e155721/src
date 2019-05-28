VerifAcc <- function(gold.aln, psa.aln)
{
  regions <- length(gold.aln)
  match <- 0  
  i <- 1
  while (i <= regions) {
    gold <- paste(gold.aln[[i]][1, -1], gold.aln[[i+1]][1, -1], sep = "", collapse = "")
    psa <- paste(psa.aln[[i]][1, -1], psa.aln[[i+1]][1, -1], sep = "", collapse = "")
    i <- i+2
    # counting correct alignment
    if (gold == psa) {
      match <- match+1
    }
  }
  
  npairs <- regions/2
  matching.rate <- match / npairs * 100
  
  return(matching.rate)
}
