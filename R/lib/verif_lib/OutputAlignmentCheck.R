OutputAlignmentCheck <- function(f, output.path, ext, psa, gold)
{
  # countting the number of matched alignments
  N <- length(psa)
  match <- 0  
  for (i in 1:N) {
    psa.aln <- paste(psa[[i]]$aln, collapse = "")
    gold.aln <- paste(gold[[i]]$aln, collapse = "")
    region <- paste(psa[[i]]$seq1[1, 1], psa[[i]]$seq2[1, 1], sep = "/" )
    
    if (psa.aln == gold.aln) {
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
  }
  
  return(0)
}
