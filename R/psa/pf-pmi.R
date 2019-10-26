source("lib/load_scoring_matrix.R")
source("lib/load_verif_lib.R")
source("verification/methods/MakeCorpus.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

PairwisePFPMI <- function(word.list, s) {
  # Comptes the pairwise alignment using PF-PMI-weighting.
  # Args:
  #   word.list: The list of words.
  #   s: The scoring matrix.
  #
  # Returns:
  #   psa.aln: The list of PSA.
  E <- 1/1000  # epsilon size
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
      
      as.max <- which(as.tmp == max(as.tmp))
      psa.aln <- psa.tmp[[as.max]]
      
      loop <- 1
      break 
    } else {
      loop <- loop + 1
    }
    
    # calculating PMI
    newcorpus <- MakeCorpus(psa.aln)
    co.mat <- MakeCoMat(newcorpus)
    v.vec <- dimnames(co.mat)[[1]]
    V <- length(v.vec)
    N <- length(newcorpus)
    N <- N - (sum(newcorpus == "-") * 2)
    E <- 1
    for (i in 1:V) {
      for (j in 1:V) {
        a <- v.vec[i]
        b <- v.vec[j]
        if (a != b) {
          if ((a!="-") && (b!="-")) {
            p.xy <- (co.mat[a, b]/N)+E
            p.x <- (g(a, newcorpus)/N)
            p.y <- (g(b, newcorpus)/N)
            pmi <- log2(p.xy/(p.x*p.y))
            s[a, b] <- pmi
          }
        }
      }
    }
    # END OF LOOP
  }
  return(psa.aln)
}

