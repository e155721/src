# forward algorithm

# Initialization
f.M <- matrix(0, n, m)
f.X <- matrix(0, n, m)
f.Y <- matrix(0, n, m)

f.M[2, 2] <- 1-2*delta-tau.M
f.X[2, 2] <- delta
f.Y[2, 2] <- delta

# Induction
for (i in 2:n) {
  for (j in 2:m) {
    if ((i!=2) && (j!=2)) {
      f.M[i, j] <- p.xy[O1[i], O2[j]] * ((1-2*delta-tau.M) * f.M[i-1, j-1] + (1-epsilon-lambda-tau.XY) * (f.X[i-1, j-1] + f.Y[i-1, j-2]))
      f.X[i, j] <- q.x[O1[i]] * (delta * f.M[i-1, j] + epsilon * f.X[i-1, j] + lambda * f.Y[i-1, j])
      f.Y[i, j] <- q.y[O2[j]] * (delta * f.M[i, j-1] + lambda * f.X[i, j-1] + epsilon * f.Y[i, j-1])
    }
  }
}

# Termination
Po <- tau.M * f.M[n, m] + tau.XY * (f.X[n, m] + f.Y[n, m])

list.f <- list(f.M, f.X, f.Y)
names(list.f) <- c("M", "X", "Y")
