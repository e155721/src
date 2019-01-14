
source("verification_multiple/ProgressiveAlignment.R")
source("verification_multiple/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")


RemoveFirst <- function(wordList, p, s)
{
  ## progressive alignmen
  paRlt <- ProgressiveAlignment(wordList, p, s)
  pa <- paRlt$multi
  beforeScore <- paRlt$score
  
  ## iterative refinement
  # number of sequences
  N <- dim(pa)[1]
  # exit condition
  count <- 0
  max <- 2*N*N
  
  i <- 1
  while (i <= N) {
    # remove ith sequence
    seq1 <- pa[drop = F, i, ]
    seq2 <- as.matrix(pa[-i, ])
    if (dim(seq2)[2] == 1) {
      seq2 <- t(seq2)
    }    
    
    # new pairwise alignment
    aln <- NeedlemanWunsch(seq1, seq2, p, p, s)
    newPa <- DelGap(aln$multi)
    afterScore <- aln$score
    
    # refine score
    if (afterScore > beforeScore) {
      count <- count + 1
      pa <- newPa
      beforeScore <- afterScore
    } else {
      i <- i + 1
    }
    
    # exit condition
    if (count == max) {
      break
    }
  }
  
  return(pa)
}
