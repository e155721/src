library(MCMCpack)
library(gtools)

O1 <- c(NA, "k", "u", "b", "-")
O2 <- c(NA, "k", "u", "b", "i")

n <- length(O1)
m <- length(O2)

V <- unique(append(O1, O2))[-1]  # removing NA
gap <- grep("-", V)
if (sum(gap) != 0) {
  V <- V[-gap] # removing gap 
}
V <- append(V, "-") # adding gap in the tail
M <- length(V)  # number of emission symbols

S <- c("M","X","Y","End")  # set of states
N <- 4  # number of states

# Initializes matrix which is symbol pairs emission probability.
p.xy <- matrix(0, M, M)
p.x <- c(0)
p.y <- c(0)

for (i in 1:M-1)
  p.xy[i, 1:M-1] <- rdirichlet(1, matrix(1,1,M-1))
p.x <- append(as.vector(rdirichlet(1, matrix(1,1,M-1))), p.x)
p.y <- append(as.vector(rdirichlet(1, matrix(1,1,M-1))), p.y)

dimnames(p.xy) <- list(V, V)
names(p.x) <- V
names(p.y) <- V

# transition proboility
A <- matrix(0, N, N, dimnames = list(S, S))
pi <- rdirichlet(1, matrix(1,1,5))
epsilon <- pi[1]
lambda <- pi[2]
delta <- pi[3]
tau.XY <- pi[4]
tau.M <- pi[5]

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
      f.M[i, j] <- p.xy[O1[i], O2[j]] * ((1-2*delta-tau.M) * f.M[i-1, j-1] + (1-epsilon-lambda-tau.XY) * (f.X[i-1, j-1]+f.Y[i-1, j-2]))
      f.X[i, j] <- p.x[O1[i]] * (delta * f.M[i-1, j] + epsilon * f.X[i-1, j] + lambda * f.Y[i-1, j])
      f.Y[i, j] <- p.y[O2[j]] * (delta * f.M[i, j-1] + lambda * f.X[i, j-1] + epsilon * f.Y[i, j-1])
    }
  }
}

# Termination
Po <- tau.M * f.M[n, m] + tau.XY * (f.X[n, m] + f.Y[n, m])

