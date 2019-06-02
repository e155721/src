OutputAlignmentCheck <- function(f, output.path, ext, x, y)
{
  # countting the number of matched alignments
  N <- length(x)
  match <- 0  
  i <- 1
  while (i <= N) {
    x.aln <- paste(x[[i]][1, -1], x[[i+1]][1, -1], collapse = "")
    y.aln <- paste(y[[i]][1, -1], y[[i+1]][1, -1], collapse = "")
    region <- paste(x[[i]][1, 1], y[[i]][1, 1], sep = "/" )
    
    if (x.aln == y.aln) {
      sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
      print(paste(region, "Match"))
      cat ("\n\n")
      sink()
    } else {
      sink(paste(output.path, gsub("\\..*$", "", f), ext, sep = ""), append = T)
      print(paste(region, "Mis"))
      cat ("\n\n")
      sink()
    }
    i <- i+2
  }
  
  return(0)
}