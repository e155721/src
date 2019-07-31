library(MCMCpack)
library(gtools)

# M state
M <- function(i, Q, S, A, B, K)
{
  a <- A[i, ]
  b <- B[i, ]
  s <- S[, sample(K, size = 1, replace = F, prob = b), drop=F]
  j <- sample(Q, size = 1, replace = F, prob = a)
  o <- list(j, s)
  return(o)
}

# X or Y state
XY <- function(i, Q, S, A, B, K)
{
  a <- A[i, ]
  b <- B[i, ]
  s <- S[, sample(K, size = 1, replace = F, prob = b)]
  j <- sample(Q, size = 1, replace = F, prob = a)
  if (i == 2) {
    o <- list(j, as.matrix(c(s[!is.na(s)], "-")))
  } else {
    o <- list(j, as.matrix(c("-", s[!is.na(s)])))
  }
  return(o)
}

PHMM <- function(U, Q, S, pi, A, B)
{
  K <- dim(S)[2]
  O <- matrix(NA, 2, 0)
  i <- sample(Q, size = 1, replace = F, prob = pi)
  
  for (t in 1:U) {  
    # M state
    if (i == 1) {
      o <- M(i, Q, S, A, B, K)
    }
    else if (i == 2 || i == 3) {
      # X or Y state
      o <- XY(i, Q, S, A, B, K)
    } else {
      # End state
      break
    }
    i <- o[[1]]
    O <- cbind(O, o[[2]])
  }
  return(O)
}

# set of states
Q <- c(1,2,3,4)
# number of states
N <- length(Q)
# set of base output symbols
S.base <- c("A", "B", "C")
# number of base outputs symbols
K.base <- length(S.base)
# set of output symbols
S <- t(permutations(n=K.base, r=2, v=S.base, repeats.allowed = T))
S.tmp <- matrix(NA, 2, K.base)
S.tmp[1, ] <- S.base
S <- cbind(S.tmp, S)
# number of output symbols
K <- dim(S)[2]

# initial proboility
pi <- rdirichlet(1, matrix(1,1,N))
# transition proboility
A <- matrix(0, N, N)
tr.vec <- rdirichlet(1, matrix(1,1,5))
epsilon <- tr.vec[1]
lambda <- tr.vec[2]
delta <- tr.vec[3]
tau.xy <- tr.vec[4]
tau.m <- tr.vec[5]
# M
A[1, 1] <- 1-2*delta-tau.m
A[1, 2:3] <- delta
A[1, 4] <- tau.m
# XY
A[2:3, 1] <- 1-epsilon-lambda-tau.xy
A[2:3, 2] <- epsilon
A[2:3, 3] <- lambda
A[2:3, 4] <- tau.xy
# End
A[4, ] <- 0

# output proboility
B <- matrix(0, N, K)
B[1, (K.base+1):K] <- rdirichlet(1, matrix(1,1,(K-K.base)))
B[2, 1:K.base] <- rdirichlet(1, matrix(1,1,K.base))
B[3, 1:K.base] <- rdirichlet(1, matrix(1,1,K.base))

# max time
U <- 100
PHMM(U, Q, S, pi, A, B)
