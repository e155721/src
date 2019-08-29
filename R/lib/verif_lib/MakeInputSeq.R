MakeInputSeq <- function(gold.seq)
{
  input.seq <- list()
  
  N <- length(gold.seq)
  for (i in 1:N) {
    gap.exist <- sum(gold.seq[[i]]=="-")
    if (gap.exist != 0) {
      input.seq[[i]] <- gold.seq[[i]][1, -which(gold.seq[[i]]=="-"), drop=F]
    } else {
      input.seq[[i]] <- gold.seq[[i]]
    }
  }
  return(input.seq)
}
