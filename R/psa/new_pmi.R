source("lib/load_verif_lib.R")
source("verification/methods/PMI.R")

library(gtools)
library(foreach)
library(doParallel)
registerDoParallel(detectCores())

MakeInputList <- function(files) {
  
  input.list <- list()
  num.input.list <- length(files)
  for (i in 1:num.input.list)
    input.list[[i]] <- MakeInputSeq(MakeWordList(files[[i]]["input"]))
  
  return(input.list)
}

MakePSA <- function(input.list, s) {
  cat("\n")
  print("Calculate PSA")
  
  num.words <- length(input.list)
  psa.list <- list()
  psa.list <- foreach (i = 1:num.words) %dopar%
    MakePairwise(input.list[[i]], s, select.min = T)
  
  return(psa.list)
}

CalcPMI <- function(psa.list, s) {
  cat("\n")
  print("Calculate PMI")
  
  # Caluculates the PMI.
  newcorpus <- MakeCorpus(psa.list)
  V <- unique(as.vector(newcorpus))
  V <- permutations(length(V), 2, v=V)
  len <- dim(V)[1]
  score.vec <- list()
  pmi.list <- foreach(i = 1:len) %dopar% {
    score.vec$V1 <- V[i, 1]
    score.vec$V2 <- V[i, 2]
    score.vec$pmi <- -PMI(V[i, 1], V[i, 2], newcorpus, E)
    return(score.vec)
  }
  
  pmi.tmp <- foreach(i = 1:len, .combine = c) %dopar%
    pmi.list[[i]]$pmi
  pmi.max <- max(pmi.tmp)
  pmi.min <- min(pmi.tmp)
  
  # Converts the PMI to the weight of edit operations.
  for (i in 1:len) {
    s[pmi.list[[i]]$V1, pmi.list[[i]]$V2] <- (pmi.list[[i]]$pmi - pmi.min) / (pmi.max - pmi.min)
    #print(paste((i/len)*100, "%"))
  }
  
  s[1:81, 82:118] <- Inf
  s[82:118, 1:81] <- Inf
  
  return(s)
}

PairwisePMI <- function(input.list, s) {
  
  psa.list <- MakePSA(input.list, s)
  
  as <- 0  
  while(1) {
    
    # Updates the old scoring matrix and the alignment.
    as.new <- 0
    M <- length(psa.list)
    for (i in 1:M) {
      N <- length(psa.list[[i]])
      for (j in 1:N) 
        as.new <- as.new + psa.list[[i]][[j]]$score
    }
    
    print(paste("Old Edit Distance:", as))
    print(paste("New Edit Distance:", as.new))
    
    # Checks the convergence of the PMI.
    if (as == as.new) {
      break
    } else {
      as <- as.new
    }
    
    s <- CalcPMI(psa.list, s)
    psa.list <- MakePSA(input.list, s)
    
  }
  
  return(s)
}
