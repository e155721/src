VerifAcc <- function(x, y)
{
  # countting the number of matched alignments
  N <- length(x)
  match <- 0  
  i <- 1
  while (i <= N) {
    x.aln <- paste(x[[i]][1, ], x[[i+1]][1, ], collapse = "")
    y.aln <- paste(y[[i]][1, ], y[[i+1]][1, ], collapse = "")
    i <- i+2
    if (x.aln == y.aln) {
      match <- match+1
    }
  }
  
  # calculating the matching rate
  npairs <- N/2
  matching.rate <- (match/npairs)*100
  
  return(matching.rate)
}
