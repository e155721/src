OutputAlignment <- function(f, output.path, ext, psa)
{
  # output alignments
  N <- length(psa)
  i <- 1
  while (i <= N) {
    # by The Needleman-Wunsch
    sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
    cat(paste(i, " "))
    print(paste(psa[[i]], collapse = " "), quote = F)
    cat(paste(i+1, " "))
    print(paste(psa[[i+1]], collapse = " "), quote = F)
    cat("\n")
    sink()
    i <- i+2
  }
  
  return(0)
}
