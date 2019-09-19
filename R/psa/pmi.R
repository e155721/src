source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakeEDPairwise.R")
source("verification/methods/MakeCorpus.R")
source("verification/methods/PMI.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

PmiWeighted <- function(word.list) {
  # epsilon size
  E <- 1/1000
  
  # make scoring matrix
  s <- MakeEditDistance(Inf)
  
  # making the pairwise alignment in all regions
  psa.rlt <- MakeEDPairwise(word.list, s, select.min = T)
  psa.aln <- psa.rlt$psa
  ed <- psa.rlt$ed
  
  # store the org scoring matrix
  s.old <- s
  
  ed.new <- 0
  loop <- 0
  sum.ed <- NULL        
  sum.ed.vec <- c()
  while (1) {
    # calculating PMI
    newcorpus <- MakeCorpus(psa.aln)
    co.mat <- MakeCoMat(newcorpus)
    v.vec <- dimnames(co.mat)[[1]]
    V <- length(v.vec)
    N <- length(newcorpus)
    maxpmi <- 0
    E <- 1
    for (i in 1:V) {
      for (j in 1:V) {
        a <- v.vec[i]
        b <- v.vec[j]
        if (a!=b) {
          p.xy <- (co.mat[a, b]/N)+E
          p.x <- (g(a, newcorpus)/N)
          p.y <- (g(b, newcorpus)/N)
          pmi <- log2(p.xy/(p.x*p.y))
          s[a, b] <- pmi
          maxpmi <- max(maxpmi, pmi)
        }
      }
    }
    maxpmi <- max(maxpmi)[1]
    
    for (a in v.vec) {
      for (b in v.vec) {
        if (a != b) {
          s[a, b] <- 0-s[a, b]+maxpmi
        }
      }
    }
    
    # updating CV penalties
    s[1:81, 82:118] <- Inf
    s[82:118, 1:81] <- Inf
    
    # updating old scoring matrix
    s.old <- s
    
    # making the pairwise alignment in all regions
    psa.rlt <- MakeEDPairwise(word.list, s, select.min = T)
    psa.aln <- psa.rlt$psa
    ed.new <- psa.rlt$ed
    
    # exit condition
    if (ed == ed.new) {
      break
    } else {
      ed <- ed.new
    }
    
    # breaking infinit loop
    if (!is.null(sum.ed)) {
      if (ed == sum.ed) {
        break
      } else {
        loop <- loop+1
      }
      if (loop == 3) {
        sum.ed <- NULL
        sum.ed.vec <- c()
        loop <- 0
      }
    }
    sum.ed.vec <- append(sum.ed, ed)
    sum.ed <- min(sum.ed.vec)
  }
  
  return(psa.aln)
}
