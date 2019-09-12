Gamma.uv <- function(i, u, v, list.f, list.b) {
  
  fb.i <- list.f[[i]][u, v] * list.b[[i]][u, v]
  
  fb.j <- 0
  for (j in 1:N) {
    fb.j <- fb.j + list.f[[j]][u, v] * list.b[[j]][u, v]
  }
  
  gamma <- fb.i / fb.j
  if (is.na(gamma)) {
    return(0)
  } 
  else if (is.infinite(gamma)) {
    return(0)
  } else {
    return(gamma)
  }
}