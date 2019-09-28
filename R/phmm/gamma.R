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

ExeGamma <- function(O, fb) {
  
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
        e.k <- 0
        for (u in 2:U) {
          for (v in 2:V) {
            if (O1[u]==k.x && O2[v]==k.y) {
              e.k <- e.k + Gamma(i, u, v, fb)
            }
          }
        }
        p.xy_[k.x, k.y] <- e.k
        
        # i = X
        e.k <- 0
        for (u in 2:U) {
          for (v in 2:V) {
            if (O1[u]==k.x) {
              e.k <- e.k + Gamma(i, u, v, fb)
            }
          }
        }
        q.x_[1, k.x] <- e.k
        
        # i = Y
        e.k <- 0
        for (u in 2:U) {
          for (v in 2:V) {
            if (O2[v]==k.y){
              e.k <- e.k + Gamma(i, u, v, fb)
            }
          }
        }
        q.y_[1, k.y] <- e.k
        
      }
    }
    
  }
  
  p.xy_ <- p.xy_ / sum(p.xy_)
  q.x_ <- q.x_ / sum(q.x_)
  q.y_ <- q.y_ / sum(q.y_)
  
  E_ <- list(p.xy_, q.x_, q.y_)
  names(E_) <- c(S)
  
  return(E_)    
}
