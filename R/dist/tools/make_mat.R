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

align <- function(c1, c2, method, s) {
  
  N1 <- length(c1)
  N2 <- length(c2)
  ldn.vec <- NULL
  
  for (i in 1:N1) {
    for (j in 1:N2) {
      as      <- NeedlemanWunsch(c1[[i]], c2[[j]], s, select.min = is.dist(method))$score
      ldn     <- as / max(length(c1[[i]]), length(c2[[j]]))
      ldn.vec <- c(ldn.vec, ldn)
    }
  }
  
  if (is.dist(method)) {
    ldn <- min(ldn.vec)
  } else {
    ldn <- max(ldn.vec)
  }
  
  return(ldn)
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
          "pmi" = load("../../Alignment/ex_05-21/score_psa_pmi_base_2020-05-21.RData")
  )

  concepts <- names(r1)  
  mat <- matrix(NA, N, N, dimnames = list(concepts, concepts))
  for (i in 1:N) {
    for (j in 1:N) {
      
      mat[i, j] <- align(r1[[i]], r2[[j]], method, s)
      
    }
  }
  
  return(mat)
}
