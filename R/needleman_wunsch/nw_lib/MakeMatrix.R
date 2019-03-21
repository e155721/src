# this function makes matrix for sequence alignment
MakeMatrix <- function(seq1, seq2)
{
  len1 <- dim(seq1)[2]
  len2 <- dim(seq2)[2]
  x <- array(dim=c(len1, len2, 2))
  
  return(x)
}