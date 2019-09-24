Forward <- function(O, params, E) {
  # Computes the likelihood using forward algorithm.
  # 
  # Args:
  #   O: The list of the observation sequences and the lengths.
  #   params: The list of the parameters.
  #
  # Returns:
  #   The list of the distance matrices in each state.
  O1 <- O$O1
  O2 <- O$O2
  U <- O$U
  V <- O$V
  
  delta <- params["delta"]
  tau.M <- params["tau.M"]
  epsilon <- params["epsilon"]
  lambda <- params["lambda"]
  tau.XY <- params["tau.XY"]
  
  p.xy <- E$M
  q.x <- E$X
  q.y <- E$Y
  
  m.m <- 1-2*delta-tau.M
  xy.m <- 1-epsilon-lambda-tau.XY
  
  # Initialization
  f.M <- matrix(0, U+1, V+1)
  f.X <- matrix(0, U+1, V+1)
  f.Y <- matrix(0, U+1, V+1)
  
  f.M[2, 2] <- m.m
  f.X[2, 2] <- delta
  f.Y[2, 2] <- delta
  
  # Induction
  for (i in 2:U) {
    for (j in 2:V) {
      if ((i != 2) && (j != 2)) {
        f.M[i, j] <- p.xy[O1[i], O2[j]] * ((m.m) * f.M[i-1, j-1] + (xy.m) * (f.X[i-1, j-1] + f.Y[i-1, j-2]))
        f.X[i, j] <- q.x[1, O1[i]] * (delta * f.M[i-1, j] + epsilon * f.X[i-1, j] + lambda * f.Y[i-1, j])
        f.Y[i, j] <- q.y[1, O2[j]] * (delta * f.M[i, j-1] + lambda * f.X[i, j-1] + epsilon * f.Y[i, j-1])
      }
    }
  }
  
  # Termination
  # Po <- tau.M * f.M[n, m] + tau.XY * (f.X[n, m] + f.Y[n, m])
  
  f.val <- list(f.M, f.X, f.Y)
  names(f.val) <- c(S)
  
  return(f.val)
}
