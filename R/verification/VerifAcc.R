VerifAcc <- function(gold.aln, psa.aln, regions)
{
  N <- length(gold.aln)
  print(N)
  match <- 0  
  i <- 1
  while (i <= N) {
    gold <- paste(gold.aln[[i]][1, -1], gold.aln[[i+1]][1, -1], sep = "", collapse = "")
    psa <- paste(psa.aln[[i]][1, -1], psa.aln[[i+1]][1, -1], sep = "", collapse = "")
    i <- i+2
    # counting correct alignment
    if (gold == psa) {
      match <- match+1
    }
  }
  
  npairs <- sum((regions-1):1)
  matching.rate <- match / npairs * 100
  
  return(matching.rate)
}

