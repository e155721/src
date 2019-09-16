library(MCMCpack)
library(gtools)

# M state
M <- function(Q, i, S, A, B, K) {
  # Computes the next state and symbol pair in the state M.
  #
  # Args:
  #   Q: The vector of states.
  #   i: The number of current state.
  #   S: The vector of symbols.
  #   A: The matrix of probability of state transition.
  #   B: The matrix of probability of symbol emission.
  #   K: The number of emission symbol pairs.
  #
  # Returns:
  #   The list of the next state and symbol pair in the state M.
  a <- A[i, ]
  b <- B[i, ]
  j <- sample(Q, size = 1, replace = F, prob = a)
  o <- S[, sample(K, size = 1, replace = F, prob = b), drop=F]
  next.val <- list(j, o)
  names(next.val) <- c("j", "o")

  return(next.val)
}

# X or Y state
XY <- function(Q, i, S, A, B, K) {
  # Computes the next state and symbol pair in the state X or Y.
  #
  # Args:
  #   i: The number of current state.
  #   S: The vector of symbols.
  #   A: The matrix of probability of state transition.
  #   B: The matrix of probability of symbol emission.
  #   K: The number of emission symbol pairs.
  #
  # Returns:
  #   The list of the next state and symbol pairs in the state X or Y.
  a <- A[i, ]
  b <- B[i, ]
  j <- sample(Q, size = 1, replace = F, prob = a)
  o <- S[, sample(K, size = 1, replace = F, prob = b)]
  next.val <- list(j, o)
  names(next.val) <- c("j", "o")

  return(next.val)
}

PHMM <- function(pi, Q, S, A, B, FT) {
  # Outputs the symbol pair series.
  #
  # Args:
  #   i: The number of current state.
  #   S: The vector of symbols.
  #   A: The matrix of probability of state transition.
  #   B: The matrix of probability of symbol emission.
  #   K: The number of emission symbol pairs.
  #   FT: The final time.
  #
  # Returns:
  #   The matrix of symbol pair series which it was calculated following the PHMM's parameters.
  MXY <- Q[-4]
  i <- sample(MXY, size = 1, replace = F, prob = pi)
  K <- dim(S)[2]
  O <- matrix(NA, 2, 0)

  for (t in 1:FT) {
    if (i == "M") {
      next.val <- M(Q, i, S, A, B, K)
    }
    else if (i == "X" || i == "Y") {
      next.val <- XY(Q, i, S, A, B, K)
    } else {
      # End state
      break
    }
    i <- next.val$j
    O <- cbind(O, next.val$o)
  }

  return(O)
}
