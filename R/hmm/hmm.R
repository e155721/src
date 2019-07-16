library(MCMCpack)

q <- function(i, Q, S, A, B)
{
  a <- A[i, ]
  b <- B[i, ]
  s <- sample(S, size = 1, replace = F, prob = b)
  j <- sample(Q, size = 1, replace = F, prob = a)
  # cat(s)
  # cat(" ")
  ab <- list(j, s)
  return(ab)
}

HMM <- function(U, Q, S, pi, A, B)
{
  O <- c(NULL)
  i <- sample(Q, size = 1, replace = F, prob = pi)
  for (t in 1:U) {
    ab <- q(i, Q, S, A, B)
    i <- ab[[1]]
    O <- append(O, ab[[2]])
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

pi <- rdirichlet(1, matrix(1,1,N))
A <- matrix(c(.4,.3,.6,.7),N,N)
B <- matrix(c(.5,.2,.5,.8),N,K)

# max time
U <- 100
HMM(U, Q, S, pi, A, B)
