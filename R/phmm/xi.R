Xi <- function(u, v, i, j, O1, O2, f.var, b.var, A) {
  # Computes the transition probability from state i to j at u and j.
  #
  # Args:
  #   u, v: The values of positions on both of the observation sequences.
  #   i, j: The values of states.
  #   O1, O2: The vectors of observation sequences which these have length of U and V respectively.
  #   f.var, b.var: The list of distance matrices by the forward-backward algorithm.
  #   A: The matrix of transition probability.
  #
  # Returns:
  #   The value of the transition probability from state i to j at u and j.
  switch(j,
         "M" = e.j <- p.xy[O1[u+1], O2[v+1]],
         "X" = e.j <- q.x[O1[u+1]],
         "Y" = e.j <- q.y[O2[v+1]]
  )
  
  switch(j,
         "M" = b.j <- b.var[[j]][u+1, v+1],
         "X" = b.j <- b.var[[j]][u+1, v],
         "Y" = b.j <- b.var[[j]][u, v+1]
  )
  
  num <- f.var[[i]][u, v] * A[i, j] * e.j * b.j
  
  den <- 0
  for (k in 1:3) {
    den <- den + f.var[[k]][u, v] * b.var[[k]][u, v]
  }
  
  xi <- num / den
  if (is.na(xi)) {
    return(0)
  } 
  else if (is.infinite(xi)) {
    return(0)
  } else {
    return(xi)
  }
  
  return(xi)  
}


