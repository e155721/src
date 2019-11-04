source("lib/load_verif_lib.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

MakeCorpus <- function(psa.aln) {
  # Makes the corpus to calculate PMI.
  #
  # Args:
  #   psa.aln: A list of an pairwise sequence aligment resutls.
  #
  # Returns:
  #   A corpus to calculate PMI.
  N <- length(psa.aln)
  seq1 <- NULL
  seq2 <- NULL
  
  for (i in 1:N) {
    seq1 <- cbind(seq1, psa.aln[[i]]$seq1[1, -1, drop=F])
    seq2 <- cbind(seq2, psa.aln[[i]]$seq2[1, -1, drop=F])
  }
  corpus <- rbind(seq1, seq2)
  
  # Removes identical segments from the corpus.
  corpus <- corpus[, -which(seq1 == seq2), drop=F]
  corpus <- corpus[, -which(corpus[1, ] == "-"), drop=F]
  corpus <- corpus[, -which(corpus[2, ] == "-"), drop=F]
  return(corpus)
}

PairwisePFPMI <- function(word.list, s) {
  # Comptes the pairwise alignment using PMI-weighting.
  # Args:
  #   word.list: The list of words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   psa.aln: The list of PSA.
  kMaxLoop <- 10  # number of max loop
  
  as <- 0
  loop <- 1
  psa.tmp <- list()
  as.tmp <- NULL
  while (1) {
    # START OF LOOP
    # updating CV penalties
    s[1:81, 82:118] <- -Inf
    s[82:118, 1:81] <- -Inf
    psa.aln <- MakePairwise(word.list, s, select.min = F)
    
    # Updates the old scoring matrix and the alignment.
    as.new <- 0
    N <- length(psa.aln)
    for (i in 1:N)
      as.new <- as.new + psa.aln[[i]]$score
    psa.tmp[[loop]] <- psa.aln
    as.tmp <- c(as.tmp, as.new)
    
    # Checks the convergence of the PMI.
    if (as == as.new) {
      break
    } else {
      as <- as.new
    }
    
    # Checks the number of loops.
    if (loop == kMaxLoop) {
      print(length(psa.tmp))
      psa.tmp <- tail(psa.tmp, 2)
      as.tmp <- tail(as.tmp, 2)
      
      as.max <- which(as.tmp == max(as.tmp))
      psa.aln <- psa.tmp[[as.max]]
      
      loop <- 1
      break
    } else {
      loop <- loop + 1
    }
    
    # Caluculates the PMI.
    newcorpus <- MakeCorpus(psa.aln)
    V <- unique(as.vector(newcorpus))
    pmi.tmp <- NULL
    for (a in V) {
      for (b in V) {
        if (a != b) {
          pmi <- PMI(a, b, newcorpus, E)
          s[a, b] <- pmi
          pmi.tmp <- c(pmi.tmp, pmi)
        }
      }
    }
    pmi.max <- max(pmi.tmp)
    pmi.min <- min(pmi.tmp)
    
    # Converts the PMI to the weight of edit operations.
    for (a in V) {
      for (b in V) {
        if (a != b) {
          s[a, b] <- (s[a, b] - pmi.min) / (pmi.max - pmi.min)
        }
      }
    }
    # END OF LOOP    
  }
  return(psa.aln)
}
