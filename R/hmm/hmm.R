library(MCMCpack)

q <- function(i, Q, S, A, B)
{
  a <- A[i, ]
  b <- B[i, ]
  s <- sample(S, size = 1, replace = F, prob = b)
  j <- sample(Q, size = 1, replace = F, prob = a)
  # cat(s)
  # cat(" ")
  o <- list(j, s)
  return(o)
}

HMM <- function(U, Q, S, pi, A, B)
{
  O <- c(NULL)
  i <- sample(Q, size = 1, replace = F, prob = pi)
  for (t in 1:U) {
    o <- q(i, Q, S, A, B)
    i <- o[[1]]
    O <- append(O, o[[2]])
  }
  return(O)
}

# set of states
Q <- c(1,2,3)
# numbet of states
N <- length(Q)

# set of output symbols
S <- c("A", "B", "C")
# number of outputs symbols
K <- length(S)

# initial probability
pi <- rdirichlet(1, matrix(1,1,N))

# transition and emission probability
A <- matrix(0, N, N)
B <- matrix(0, N, K)
for (i in 1:N) {
  A[i, ] <- rdirichlet(1, c(1,1,N))
  B[i, ]<- rdirichlet(1, c(1,1,N))
}

# max time
U <- 100
HMM(U, Q, S, pi, A, B)
