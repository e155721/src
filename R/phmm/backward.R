# backward algorithm

# Initialization
b.M <- matrix(0, n, m)
b.X <- matrix(0, n, m)
b.Y <- matrix(0, n, m)

b.M[n-1, m-1] <- tau.M
b.X[n-1, m-1] <- tau.XY
b.Y[n-1, m-1] <- tau.XY

# Induction
for (i in (n-1):1) {
  for (j in (m-1):1) {
    if (i!=(n-1) && j!=(m-1)) {
      b.M[i, j] <- (1-2*delta-tau.M) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + delta * (q.x[O1[i+1]] * b.X[i+1, j] + q.y[O2[j+1]] * b.Y[i, j+1])
      b.X[i, j] <- (1-epsilon-lambda-tau.XY) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + epsilon * q.x[O1[i+1]] * b.X[i+1, j] + lambda * q.y[O2[j+1]] * b.Y[i, j+1]
      b.Y[i, j] <- (1-epsilon-lambda-tau.XY) * p.xy[O1[i+1], O2[j+1]] * b.M[i+1, j+1] + lambda * q.x[O1[i+1]] * b.X[i+1, j] + epsilon * q.y[O2[j+1]] * b.Y[i, j+1]
    }
  }
}

# Termination
Po <- (1-2*delta-tau.M) * b.M[1, 1] + delta * (b.X[1, 1] + b.Y[1, 1])

list.b <- list(b.M, b.X, b.Y)
names(list.b) <- c("M", "X", "Y")
