Backward <- function(O, params, E) {
  # Computes the likelihood using backward algorithm.
  #
  # Arugs:
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
  b.M <- matrix(0, U+1, V+1)
  b.X <- matrix(0, U+1, V+1)
  b.Y <- matrix(0, U+1, V+1)
  
  b.M[U, V] <- tau.M
  b.X[U, V] <- tau.XY
  b.Y[U, V] <- tau.XY
  
  # Induction
  for (i in U:2) {
    for (j in V:2) {
      if ((i != U) && (j != V)) {
        b.M[i, j] <- (m.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + delta * (q.x[1, O1[i+1]] * b.X[i+1, j] + q.y[1, O2[j+1]] * b.Y[i, j+1])
        b.X[i, j] <- (xy.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + epsilon * q.x[1, O1[i+1]] * b.X[i+1, j] + lambda * q.y[1, O2[j+1]] * b.Y[i, j+1]
        b.Y[i, j] <- (xy.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + lambda * q.x[1, O1[i+1]] * b.X[i+1, j] + epsilon * q.y[1, O2[j+1]] * b.Y[i, j+1]
      }
    }
  }
  
  # Termination
  # Po <- (1-2*delta-tau.M) * b.M[1, 1] + delta * (b.X[1, 1] + b.Y[1, 1])
  
  b.val <- list(b.M, b.X, b.Y)
  names(b.val) <- c(S)
  
  return(b.val)
}
