Gamma <- function(i, u, v, fb) {
  # Computes the visited probability of state i at u and v.
  #
  # Args:
  #   i: The value of state.
  #   u, v: The values of positions on both of the observation sequences.
  #   fb: The list of the forward-backward algorithm.
  #
  # Returns:
  #   The value of visited probability of state i at u and v.
  f.var <- fb$forward
  b.var <- fb$backward
  
  num <- f.var[[i]][u, v] * b.var[[i]][u, v]
  
  den <- 0
  for (j in 1:N) {
    den <- den + f.var[[j]][u, v] * b.var[[j]][u, v]
  }
  
  if (den == 0 ) {
    return(0)
  } else {
    gamma <- num / den
    return(gamma)
  }
  
}

ExeGamma <- function(O, fb) {
  # Computes the emission probability at state i.
  #
  # Args:
  #   O: The list of the observation sequences and the lengths.
  #   fb: The list of the forward-backward algorithm.
  #
  # Returns:
  #   The list of the emission probability matrices.
  O1 <- O$O1
  O2 <- O$O2
  U <- O$U
  V <- O$V
  
  p.xy_ <- matrix(0, M, M, dimnames = list(Sig, Sig))
  q.x_ <- matrix(0, 1, M, dimnames = list("-", Sig))
  q.y_ <- matrix(0, 1, M, dimnames = list("-", Sig))
  
  for (i in S) {
    
    for (k.x in Sig) {
      for (k.y in Sig) {
        
        # i = M
        num <- 0
        for (u in 2:U) {
          for (v in 2:V) {
            
            if ((O1[u]==k.x && O2[v]==k.y) && (i == "M")) {
              num <- num + Gamma(i, u, v, fb)
            }
            else if ((O1[u] == k.x) && (i == "X")) {
              num <- num + Gamma(i, u, v, fb)
            }
            else if ((O2[v] == k.y) && (i == "Y")) {
              num <- num + Gamma(i, u, v, fb)
            }
            
          }
        }
        
        den <- 0
        for (u in 2:U) {
          for (v in 2:V) {
            den <- den + Gamma(i, u, v, fb)
          }
        }
        
        if (den == 0) {
          e.k <- 0
        } else {
          e.k <- num / den
        }
        
        switch(i,
               "M" = p.xy_[k.x, k.y] <- e.k,
               "X" = q.x_[1, k.x] <- e.k,
               "Y" = q.y_[1, k.y] <- e.k)
        
      }
    }
    
  }
  
  sum.p.xy_ <- sum(p.xy_)
  if (sum.p.xy_ != 0) {
    p.xy_ <- p.xy_ / sum.p.xy_
  } 
  
  sum.q.x_ <- sum(q.x_)
  if (sum.q.x_ != 0) {
    q.x_ <- q.x_ / sum(q.x_)
  }
  
  sum.q.y_ <- sum(q.y_)
  if (sum.q.y_ != 0) {
    q.y_ <- q.y_ / sum(q.y_)
  }
  
  E_ <- list(p.xy_, q.x_, q.y_)
  names(E_) <- S
  
  return(E_)    
}
