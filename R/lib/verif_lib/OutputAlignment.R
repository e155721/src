OutputAlignment <- function(f, output.path, ext, psa)
{
  # output alignments
  N <- length(psa)
  for (i in 1:N) {
    # by The Needleman-Wunsch
    sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
    cat(paste(i, " "))
    print(paste(psa[[i]]$seq1, collapse = " "), quote = F)
    cat(paste(i+1, " "))
    print(paste(psa[[i]]$seq2, collapse = " "), quote = F)
    cat("\n")
    sink()
  }
  
  return(0)
}
