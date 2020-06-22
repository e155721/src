source("lib/load_scoring_matrix.R")
source("lib/load_nwunsch.R")

is.dist <- function(method) {
  
  if (method == "pf") {
    dist <- F
  } else {
    dist <- T
  }
  
  return(dist)
}

psa_for_each_form <- function(c1, c2, method, s) {
  
  N1 <- length(c1)
  N2 <- length(c2)
  
  dist <- is.dist(method)
  
  psa.list <- list()
  asn.vec  <- NULL
  for (i in 1:N1) {
    for (j in 1:N2) {
      psa           <- NeedlemanWunsch(c1[[i]], c2[[j]], s, select.min = dist)
      k             <- i + (j - 1) * N1
      psa.list[[k]] <- psa
      
      as       <- psa$score
      seq1.len <- length(psa$seq1) - 1
      seq2.len <- length(psa$seq2) - 1
      
      asn      <- as / max(seq1.len, seq2.len)
      asn.vec  <- c(asn.vec, asn)
      
      psa.list[[k]]$asn <- asn
    }
  }
  
  if (dist) {
    best <- which(asn.vec == min(asn.vec)[1])
  } else {
    best <- which(asn.vec == max(asn.vec)[1])
  }
  
  return(psa.list[[best]])
}

MakeMat <- function(r1, r2, method="lv") {
  
  n1 <- NULL
  n2 <- NULL
  
  N <- length(r1)
  for (i in 1:N) {
    n1[i] <- length(r1[[i]])
    n2[i] <- length(r2[[i]])
  }
  
  n <- n1 * n2
  zero <- rev(which(n == 0))
  
  for (i in zero) {
    r1 <- r1[-i]
    r2 <- r2[-i]
  }
  N <- length(r1)
  
  # Select a scoring matrix.
  switch (method,
          "lv"  = s <- MakeEditDistance(Inf), 
          "pf"  = s <- MakeFeatureMatrix(-Inf, -1),
          "pmi" = load("pmi_score.RData")
  )
  
  concepts <- names(r1)  
  psa.list <- list()
  mat <- matrix(NA, N, N, dimnames = list(concepts, concepts))
  for (i in 1:N) {
    for (j in 1:N) {
      c1 <- r1[[i]]
      c2 <- r2[[j]]
      
      psa           <- psa_for_each_form(c1, c2, method, s)
      k             <- i + (j - 1) * N
      psa.list[[k]] <- psa
      mat[i, j]     <- psa$asn
    }
  }
  
  mat.o          <- list()
  mat.o$psa.list <- psa.list
  mat.o$mat      <- mat
  return(mat.o)
}
