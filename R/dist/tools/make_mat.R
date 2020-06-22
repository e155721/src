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

psa <- function(c1, c2, method, s) {
  
  N1 <- length(c1)
  N2 <- length(c2)
  
  dist <- is.dist(method)
  
  asn.vec <- NULL
  for (i in 1:N1) {
    for (j in 1:N2) {
      as      <- NeedlemanWunsch(c1[[i]], c2[[j]], s, select.min = dist)$score
      c1.len  <- length(c1[[i]]) - 1
      c2.len  <- length(c2[[j]]) - 1
      asn     <- as / max(c1.len, c2.len)
      asn.vec <- c(asn.vec, asn)
    }
  }
  
  if (dist) {
    score <- min(asn.vec)
  } else {
    score <- max(asn.vec)
  }
  
  return(score)
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
  mat <- matrix(NA, N, N, dimnames = list(concepts, concepts))
  for (i in 1:N) {
    for (j in 1:N) {
      c1 <- r1[[i]]
      c2 <- r2[[j]]
      mat[i, j] <- psa(c1, c2, method, s)
    }
  }
  
  return(mat)
}
