.myfunc.env = new.env()
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("needleman_wunsch/NeedlemanWunsch.R", envir = .myfunc.env)
attach(.myfunc.env)

IterativeRefinement <- function(wordList, p, scoringMatrix)
{
  ## progressive alignmen
  paRlt <- ProgressiveAlignment(wordList, p, scoringMatrix)
  pa <- paRlt$multi
  beforeScore <- paRlt$score
  
  ## iterative refinement
  # number of sequences
  n <- dim(pa)[1]
  # exit condition
  count <- 0
  max <- 2 * n * n
  
  i <- 1
  while (i <= n) {
    # remove gaps
    seq1 <- pa[i, ]
    seq1 <- gsub("-", NA, seq1)
    seq1 <- seq1[!is.na(seq1)]
    seq1 <- t(as.matrix(seq1))
    
    # remove ith sequence
    seq2 <- pa[-i, ]
    
    # new pairwise alignment
    aln <- NeedlemanWunsch(seq1, seq2, p, p, scoringMatrix)
    newPa <- aln$multi
    afterScore <- aln$score
    
    # refine score
    if (afterScore > beforeScore) {
      count <- count + 1
      # print(paste("count:", count))
      pa <- newPa
      beforeScore <- afterScore
    } else {
      # print(paste("line:", i))
      i <- i + 1
    }
    
    # exit condition
    if (count == max) {
      break
    }
  }
  
  return(pa)
}
