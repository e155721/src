MakeInputSeq <- function(gold.list)
{
  input.seq <- list()
  
  N <- length(gold.list)
  for (i in 1:N) {
    gap.exist <- sum(gold.list[[i]]=="-")
    if (gap.exist != 0) {
      input.seq[[i]] <- gold.list[[i]][1, -which(gold.list[[i]]=="-"), drop=F]
    } else {
      input.seq[[i]] <- gold.list[[i]]
    }
  }
  return(input.seq)
}
