OutputAlignmentCheck <- function(f, output.path, ext, x, y)
{
  # countting the number of matched alignments
  N <- length(x)
  match <- 0  
  i <- 1
  while (i <= N) {
    x.aln <- paste(x[[i]], x[[i+1]], collapse = "")
    y.aln <- paste(y[[i]], y[[i+1]], collapse = "")
    region <- paste(x[[i]][1, 1], x[[i+1]][1, 1], sep = "/" )
    
    if (x.aln == y.aln) {
      sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
      print(paste("Match:", i, region))
      cat ("\n")
      sink()
    } else {
      sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
      print(paste("Mis:", i, region))
      cat ("\n")
      sink()
    }
    i <- i+2
  }
  
  return(0)
}
