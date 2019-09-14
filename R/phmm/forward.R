Forward <- function(O1, O2, params) {
  # Computes the likelihood using forward algorithm.
  # 
  # Args:
  #   O1: The vector of an observation sequence which it has length of n.
  #   O2: The vector of an observation sequence which it has length of m.
  #   params: The list of the parameters.
  #
  # Returns:
  #   The list of the distance matrices in each state.
  n <- length(O1)-1
  m <- length(O2)-1
  
  m.m <- 1-2*params$delta-params$tau.M
  xy.m <- 1-params$epsilon-params$lambda-params$tau.XY
  epsilon <- params$epsilon
  lambda <- params$lambda
  delta <- params$delta  
  
  # Initialization
  f.M <- matrix(0, n+1, m+1)
  f.X <- matrix(0, n+1, m+1)
  f.Y <- matrix(0, n+1, m+1)
  
  f.M[2, 2] <- m.m
  f.X[2, 2] <- delta
  f.Y[2, 2] <- delta
  
  # Induction
  for (i in 2:n) {
    for (j in 2:m) {
      if ((i!=2) && (j!=2)) {
        f.M[i, j] <- p.xy[O1[i], O2[j]] * ((m.m) * f.M[i-1, j-1] + (xy.m) * (f.X[i-1, j-1] + f.Y[i-1, j-2]))
        f.X[i, j] <- q.x[O1[i]] * (delta * f.M[i-1, j] + epsilon * f.X[i-1, j] + lambda * f.Y[i-1, j])
        f.Y[i, j] <- q.y[O2[j]] * (delta * f.M[i, j-1] + lambda * f.X[i, j-1] + epsilon * f.Y[i, j-1])
      }
    }
  }
  
  # Termination
  # Po <- tau.M * f.M[n, m] + tau.XY * (f.X[n, m] + f.Y[n, m])
  
  f.val <- list(f.M, f.X, f.Y)
  names(f.val) <- c("M", "X", "Y")
  
  return(f.val)
}
