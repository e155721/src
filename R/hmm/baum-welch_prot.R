# initial probability
pi <- c(1.0, 0.0, 0.0, 0.0)
# number of states
N <- 4
# output series
O <- c(1,1,2,3)
# final time
T <- length(O)

K <- 3

# A: transition probability
A <- matrix(0, N, N)
A[1,1] <- 0.7
A[1,2] <- 0.3
A[2,2] <- 0.6
A[2,3] <- 0.4
A[3,3] <- 0.1
A[3,4] <- 0.9

# B: output probability
B <- matrix(0, N, K)
B[1,1] <- 0.7
B[1,2] <- 0.2
B[1,3] <- 0.1
B[2,1] <- 0.4
B[2,2] <- 0.3
B[2,3] <- 0.3
B[3,1] <- 0.1
B[3,2] <- 0.1
B[3,3] <- 0.8

loop <- 0
while (TRUE) {
  # Start
  loop <- loop+1
  
  # Alpha
  T <- T+1
  X <- matrix(0, N, T)
  
  for (n in 1:N) {
    X[n, 1] <- pi[n]
  }
  
  for (t in 2:T) {
    X[1, t] <- X[1, t-1]*A[1,1]*B[1,O[t-1]]
  }
  
  for (n in 2:N) {
    for (t in 2:T) {
      X[n,t] <- X[n,t-1]*A[n,n]*B[n,O[t-1]] + X[n-1,t-1]*A[n-1,n]*B[n-1,O[t-1]]
    }
  }
  
  # Beta
  Y <- matrix(0, N, T)
  pi.rev <- rev(pi)
  for (n in N:1) {
    Y[n, T] <- pi.rev[n]
  }
  
  T <- T-1
  N <- N-1
  for (t in T:1) {
    Y[1, t] <- Y[1, t+1]*A[1,1]*B[1,O[t]]
  }
  
  for (n in N:1) {
    for (t in T:1) {
      Y[n,t] <- Y[n+1,t+1]*A[n,n+1]*B[n,O[t]] + Y[n,t+1]*A[n,n]*B[n,O[t]]
    }
  }
  
  # Gamma
  N <- 4
  G <- array(0, dim = c(N,N,T))
  L <- X[dim(X)[1], dim(X)[2]]
  old <- L
  for (t in 1:T) {
    for (i in 1:N) {
      for (j in 1:N) {
        G[i,j,t] <- X[i,t]*A[i,j]*B[i,O[t]]*Y[j,t+1]/L
      }
    }
  }
  
  # update A
  for (i in 1:N) {
    for (j in 1:N) {
      num <- 0
      den <- 0
      for (t in 1:T) {
        num <- num+G[i,j,t]
      }
      for (t in 1:T) {
        for (k in 1:N) {
          den <- den+G[i,k,t]
        }
      }
      a.new <- num/den
      if (is.na(a.new)) {
        A[i,j] <- 0
      } else {
        A[i,j] <- a.new
      }
    }
  }
  
  # update B
  for (j in 1:N) {
    for (o in O) {
      num <- 0
      den <- 0
      for (t in 1:T) {
        if (O[t]==o) {
          for (k in 1:N) {
            num <- num+G[j,k,t]
          }
        }
      }
      
      for (t in 1:T) {
        for (k in 1:N) {
          den <- den+G[j,k,t]
        }
      }
      b.new <- num/den
      if (is.na(b.new)) {
        B[j,o] <- 0
      } else {
        B[j,o] <- b.new
      }
    }
  }
  
  print(L)
  if (loop>2) {
    if (L==L.old) {
      break  
    }
  }
  L.old <- L
  
  # End
}
