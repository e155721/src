library(MCMCpack)

q <- function(Q, i, S, A, B) {
  # Computes the next symbol and state.
  #
  # Args:
  #   Q: The vector of states.
  #   i: The number of current state.
  #   S: The vector of symbols.
  #   A: The matrix of probability of state transition.
  #   B: The matrix of probability of symbol output.
  #
  # Returns:
  # The list of next symbol and states.
  a <- A[i, ]
  b <- B[i, ]
  j <- sample(Q, size = 1, replace = F, prob = a)
  s <- sample(S, size = 1, replace = F, prob = b)
  next.val <- list(j, s)
  names(next.val) <- c("i", "o")

  return(next.val)
}

HMM <- function(Q, pi, S, A, B, FT) {
  # Outputs the symbol series.
  #
  # Args:
  #   Q: The vector of states.
  #   pi: The vector of initial state probability.
  #   S: The vector of symbols.
  #   A: The matrix of probability of state transition.
  #   B: The matrix of probability of symbol output.
  #   FT: The final time.
  #
  # Returns:
  #   The vector of symbol series which it was calculated following the HMM's parameters.
  i <- sample(Q, size = 1, replace = F, prob = pi)
  O <- c(NULL)

  for (t in 1:FT) {
    next.val <- q(Q, i, S, A, B)
    i <- next.val$i
    O <- append(O, next.val$o)
  }

  return(O)
}
