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
for (i in 1:N) {
  A[i, ] <- rdirichlet(1, matrix(1,1,N))
}
# output proboility
B <- matrix(0, N, K)
B[1, (K.base+1):K] <- rdirichlet(1, matrix(1,1,(K-K.base)))
B[2, 1:K.base] <- rdirichlet(1, matrix(1,1,K.base))
B[3, 1:K.base] <- rdirichlet(1, matrix(1,1,K.base))

# max time
U <- 100
PHMM(U, Q, S, pi, A, B)
