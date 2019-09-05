Q <- c(1,2,3)  # set of states
N <- length(Q)  # numbet of states
pi <- rdirichlet(1, matrix(1,1,N))  # initial probability
S <- c("A", "B", "C")  # set of output symbols
K <- length(S)  # number of outputs symbols

# Creates the matrix of transition and emission probability.
A <- matrix(0, N, N)  # transition probability
B <- matrix(0, N, K)  # emission probability
for (i in 1:N) {
  A[i, ] <- rdirichlet(1, c(1,1,N))
  B[i, ]<- rdirichlet(1, c(1,1,N))
}

FT <- 100  # final time

HMM(Q, pi, S, A, B, FT)  # execution HMM
