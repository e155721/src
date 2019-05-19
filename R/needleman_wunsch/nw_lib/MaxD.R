MaxD <- function(d1, d2, d3, lenSeq1, lenSeq2, fmin)
{
  d <- c(NA, NA)
  
  if (fmin) {
    d[1] <- min(d1, d2, d3)
  } else {
    d[1] <- max(d1, d2, d3)
  }
  
  if (lenSeq1 <= lenSeq2) {
    if (d[1] == d3) {
      d[2] <- -1 # (-1,0)
    } else if (d[1] == d2) {
      d[2] <- 1 # (0,1)
    } else if (d[1] == d1) {
      d[2] <- 0 # (0,0)
    }
  }
  else if (lenSeq2 < lenSeq1) {
    if (d[1] == d2) {
      d[2] <- 1 # (0,1)
    } else if (d[1] == d3) {
      d[2] <- -1 # (-1,0)
    } else if (d[1] == d1) {
      d[2] <- 0 # (0,0)
    }
  }
  
  return(d)
}