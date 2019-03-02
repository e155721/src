source("verification_multiple/ProgressiveAlignment.R")
source("data_processing/DelGap.R")
source("needleman_wunsch/NeedlemanWunsch.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

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
    
    aln.list <- foreach (i = 1:N) %dopar% {
      # remove ith sequence
      seq1 <- pa[drop = F, i, ]
      seq2 <- pa[drop = F, -i, ]
      
      # new pairwise alignment
      #aln <- NeedlemanWunsch(seq1, seq2, p, p, s)
      NeedlemanWunsch(seq1, seq2, s)
      # scoreVec[i] <- aln$score
      # paList[[i]] <- DelGap(aln$multi)
    }
    
    for (i in 1:N) {
      #scoreVec <- unlist(aln.list$score)
      #paList <- DelGap(aln.list$multi)
      scoreVec[i] <- aln.list[[i]]$score
      paList[[i]] <- DelGap(aln.list[[i]]$multi)
    }
    
    scoreInd <- grep(scoreVec, pattern = max(scoreVec))
    scoreInd <- head(scoreInd, n = 1)
    afterScore <- scoreVec[scoreInd]
    
    # refine score
    if (afterScore > beforeScore) {
      count <- count + 1
      pa <- DelGap(paList[[scoreInd]])
      beforeScore <- afterScore
    } else {
      break
    }
  }
  
  return(pa)
}
