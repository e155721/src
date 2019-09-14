Backward <- function(O1, O2, params) {
  # Computes the likelihood using backward algorithm.
  #
  # Arugs:
  #   O1: The vector of an observation sequence which it has length of n.
  #   O2: The vector of an observation sequence which it has length of m.
  #   params: The list of the parameters.
  #
  # Returns:
  #   The list of the distance matrices in each state.
  n <- length(O1)-1
  m <- length(O2)-1
  
  delta <- params["delta"]
  epsilon <- params["epsilon"]
  lambda <- params["lambda"]
  tau.M <- params["tau.M"]
  tau.XY <- params["tau.XY"]
  
  m.m <- 1-2*delta-tau.M
  xy.m <- 1-epsilon-lambda-tau.XY
  
  # Initialization
  b.M <- matrix(0, n+1, m+1)
  b.X <- matrix(0, n+1, m+1)
  b.Y <- matrix(0, n+1, m+1)
  
  b.M[n, m] <- tau.M
  b.X[n, m] <- tau.XY
  b.Y[n, m] <- tau.XY
  
  # Induction
  for (i in n:2) {
    for (j in m:2) {
      if (i!=n && j!=m) {
        b.M[i, j] <- (m.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + delta * (q.x[O1[i+1]] * b.X[i+1, j] + q.y[O2[j+1]] * b.Y[i, j+1])
        b.X[i, j] <- (xy.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + epsilon * q.x[O1[i+1]] * b.X[i+1, j] + lambda * q.y[O2[j+1]] * b.Y[i, j+1]
        b.Y[i, j] <- (xy.m) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + lambda * q.x[O1[i+1]] * b.X[i+1, j] + epsilon * q.y[O2[j+1]] * b.Y[i, j+1]
      }
    }
  }
  
  # Termination
  # Po <- (1-2*delta-tau.M) * b.M[1, 1] + delta * (b.X[1, 1] + b.Y[1, 1])
  
  b.val <- list(b.M, b.X, b.Y)
  names(b.val) <- c("M", "X", "Y")
  
  return(b.val)
}
