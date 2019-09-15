Gamma <- function(i, u, v, f.var, b.var) {
  # Computes the visited probability of state i at u and v.
  #
  # Args:
  #   i: The value of state.
  #   u, v: The values of positions on both of the observation sequences.
  #   f.var, b.var: The list of distance matrices by the forward-backward algorithm.
  # Returns:
  #   The value of visited probability of state i at u and v.
  num <- f.var[[i]][u, v] * b.var[[i]][u, v]
  
  den <- 0
  for (j in 1:N) {
    den <- den + f.var[[j]][u, v] * b.var[[j]][u, v]
  }
  
  gamma <- num / den
  if (is.na(gamma)) {
    return(0)
  } 
  else if (is.infinite(gamma)) {
    return(0)
  } else {
    return(gamma)
  }
}