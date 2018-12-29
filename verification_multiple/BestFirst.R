.myfunc.env = new.env()
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/DelGap.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

BestFirst <- function(wordList, p, s)
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
  max <- 2 * N * N
  scoreVec <- c()
  paList <- list()
  
  while (1) {
    # exit condition
    if (count == max) {
      break
    }
    
    for (i in 1:N) {
      # remove ith sequence
      seq1 <- pa[drop = F, i, ]
      seq2 <- as.matrix(pa[-i, ])
      if (dim(seq2)[2] == 1) {
        seq2 <- t(seq2)
      }    
      
      # new pairwise alignment
      aln <- NeedlemanWunsch(seq1, seq2, p, p, s)
      scoreVec[i] <- aln$score
      paList[[i]] <- DelGap(aln$multi)
    }
    
    scoreInd <- grep(scoreVec, pattern = max(scoreVec))
    scoreInd <- head(scoreInd, n = 1)
    afterScore <- scoreVec[scoreInd]
    
    # refine score
    if (afterScore > beforeScore) {
      count <- count + 1
      pa <- paList[[scoreInd]]
      beforeScore <- afterScore
    } else {
      break
    }
  }
  
  return(pa)
}
