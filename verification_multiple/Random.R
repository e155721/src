
source("verification_multiple/ProgressiveAlignment.R")
source("verification_multiple/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")


Random <- function(wordList, p, s)
{
  ## progressive alignmen
  paRlt <- ProgressiveAlignment(wordList, p, s)
  pa <- paRlt$multi
  beforeScore <- paRlt$score
  
  ## iterative refinement
  # number of sequences
  M <- dim(pa)[1]
  N <- dim(pa)[2]
  # exit condition
  count <- 0
  max <- 2*M*M
  
  i <- 0
  while (1) {
  
    # exit condition  
    if (i == M) break
    if (count == max) break
    
    # separate msa
    R <- floor(runif(1, min=2, max=M+1))
    seq1 <- matrix(pa[1:R-1, ], R-1, N)
    seq2 <- matrix(pa[R:M, ], M-(R-1), N)
    
    # new pairwise alignment
    aln <- NeedlemanWunsch(seq1, seq2, p, p, s)
    newPa <- DelGap(aln$multi)
    afterScore <- aln$score
    
    # refine score
    if (afterScore > beforeScore) {
      count <- count + 1
      pa <- newPa
      N <- dim(pa)[2]
      beforeScore <- afterScore
    } else {
      i <- i + 1
    }
    
  }
  
  return(pa)
}
