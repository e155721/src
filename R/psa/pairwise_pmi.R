library(gtools)
library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("lib/load_exec_align.R")
source("lib/load_pmi.R")

CalcPMI <- function(psa.list, s) {
  # Compute the PMI of the PSA list.
  #
  # Args:
  #   psa.list: THe PSA list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The scoring matrix that was updated by the PMI-weighting.
  cat("\n")
  print("Calculate PMI")
  
  # Caluculate the PMI.
  corpus <- MakeCorpus(psa.list)
  # Removes identical segments from the corpus.
  corpus <- corpus[, -which(corpus[1, ] == corpus[2, ]), drop=F]
  
  V <- unique(as.vector(corpus))
  V <- permutations(length(V), 2, v=V)
  len <- dim(V)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.vec$V1  <- V[i, 1]
    score.vec$V2  <- V[i, 2]
    score.vec$pmi <- -PMI(V[i, 1], V[i, 2], corpus, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:len, .combine = c) %dopar% {
    pmi.list[[i]]$pmi
  }
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  # Convert the PMI to the weight of edit operations.
  for (i in 1:len) {
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
  }
  
  s[1:81, 82:118] <- Inf
  s[82:118, 1:81] <- Inf
  
  return(s)
}

PairwisePMI <- function(psa.list, list.words, s) {
  # Compute the new scoring matrix by updating PMI iteratively.
  #
  # Args:
  #   input.list: The word list of all the words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   s: The new scoring matrix by updating PMI iteratively.
  s.old <- s
  N <- length(s.old)
  for (i in 1:N) {
    s.old[i] <- 0
  }
  # START OF LOOP
  while(1) {
    diff <- N - sum(s == s.old)
    if (diff == 0) break
    # Compute the new scoring matrix that is updated by the PMI-weighting.
    s.old <- s
    s <- CalcPMI(psa.list, s)
    # Compute the new PSA using the new scoring matrix.
    psa.list <- PSAforAllWords(list.words, s)
  }
  # END OF LOOP
  
  return(s)
}
