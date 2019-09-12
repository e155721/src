U <- n
V <- m

# xi.uv <- array(NA, c(N, N, U, V))

Xi.uv <- function(u, v, i, j, list.f, list.b, A) {
  
  switch(j,
         "M" = e.j <- p.xy[O1[u+1], O2[v+1]],
         "X" = e.j <- q.x[O1[u+1]],
         "Y" = e.j <- q.y[O2[v+1]]
  )
  
  switch(j,
         "M" = b.j <- list.b[[j]][u+1, v+1],
         "X" = b.j <- list.b[[j]][u+1, v],
         "Y" = b.j <- list.b[[j]][u, v+1]
  )
  
  fb.ij <- list.f[[i]][u, v] * A[i, j] * e.j * b.j
  
  fb.k <- 0
  for (k in 1:3) {
    fb.k <- fb.k + list.f[[k]][u, v] * list.b[[k]][u, v]
  }
    
  xi <- fb.ij / fb.k
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

