source("lib/load_verif_lib.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

PairwisePMI <- function(word.list, s) {
  # Comptes the pairwise alignment using PMI-weighting.
  # Args:
  #   word.list: The list of words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   psa.aln: The list of PSA.
  #E <- 1/1000  # epsilon size
  E <- 1  # epsilon size
  kMaxLoop <- 10  # number of max loop
  
  as <- 0
  loop <- 1
  psa.tmp <- list()
  as.tmp <- NULL
  while (1) {
    # START OF LOOP
    # updating CV penalties
    s[1:81, 82:118] <- Inf
    s[82:118, 1:81] <- Inf
    psa.aln <- MakePairwise(word.list, s, select.min = T)
    
    # updating old scoring matrix and alignment
    as.new <- 0
    N <- length(psa.aln)
    for (i in 1:N)
      as.new <- as.new + psa.aln[[i]]$score
    
    psa.tmp[[loop]] <- psa.aln
    as.tmp <- c(as.tmp, as.new)
    
    # exit condition
    if (as == as.new) {
      break
    } else {
      as <- as.new
    }
    
    if (loop == kMaxLoop) {
      print(length(psa.tmp))
      psa.tmp <- tail(psa.tmp, 2)
      as.tmp <- tail(as.tmp, 2)
      
      as.min <- which(as.tmp == min(as.tmp))
      psa.aln <- psa.tmp[[as.min]]
      
      loop <- 1
      break
    } else {
      loop <- loop + 1
    }
    
    # calculating PMI
    newcorpus <- MakeCorpus(psa.aln)
    v.vec <- unique(as.vector(newcorpus))
    V <- length(v.vec)
    pmi.max <- 0
    for (i in 1:V) {
      for (j in 1:V) {
        a <- v.vec[i]
        b <- v.vec[j]
        if (a != b) {
          pmi <- PMI(a, b, newcorpus, E)
          s[a, b] <- pmi
          pmi.max <- max(pmi.max, pmi)
        }
      }
    }
    pmi.max <- max(pmi.max)[1]
    
    # Converts the PMI to the weight of edit operations.
    for (a in v.vec) {
      for (b in v.vec) {
        if (a != b)
          s[a, b] <- pmi.max - s[a, b]
      }
    }
    # END OF LOOP    
  }
  return(psa.aln)
}
