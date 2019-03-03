RemkSeq <- function(seq1, seq2) 
{
  seqLen <- length(seq1)
  wordMatrix <- matrix(NA, 2, seqLen)
  
  #print(seq1)
  #print(seq2)
  wordMatrix[1, ] <- seq1
  wordMatrix[2, ] <- seq2
  
  matCol <- seqLen
  j <- 1
  while (j <= matCol) {
    el <- regexpr("-", wordMatrix[, j])
    if (sum(el) == 2) {
      wordMatrix <- wordMatrix[, -j]
      matCol <- dim(wordMatrix)[2]
    } else {
      j <- j + 1
    }
  }
  return(wordMatrix)
}
