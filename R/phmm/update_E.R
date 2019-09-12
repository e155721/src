p.xy_ <- matrix(rdirichlet(1, matrix(1,1,M*M)), M, M, dimnames = list(Sig, Sig))
q.x_ <- as.vector(rdirichlet(1, matrix(1,1,M)))
q.y_ <- as.vector(rdirichlet(1, matrix(1,1,M)))

names(q.x_) <- Sig
names(q.y_) <- Sig

for (k.x in Sig) {
  for (k.y in Sig) {

    # i = M
    e.k <- 0
    for (u in 2:U) {
      for (v in 2:V) {
        if (O1[u]==k.x && O2[v]==k.y) {
          e.k <- e.k + Gamma.uv(i, u, v, list.f, list.b)
        }
      }
    }
    p.xy_[k.x, k.y] <- e.k
    
    # i = X
    e.k <- 0
    for (u in 2:U) {
      for (v in 2:V) {
        if (O1[u]==k.x && O2[v]!=k.y) {
          e.k <- e.k + Gamma.uv(i, u, v, list.f, list.b)
        }
      }
    }
    q.x_[k.x] <- e.k
    
    # i = Y
    e.k <- 0
    for (u in 2:U) {
      for (v in 2:V) {
        if (O1[u]!=k.x && O2[v]==k.y){
          e.k <- e.k + Gamma.uv(i, u, v, list.f, list.b)
        }
      }
    }
    q.y_[k.y] <- e.k
    
  }
}

p.xy_ <- p.xy_ / sum(p.xy_)
q.x_ <- q.x_ / sum(q.x_)
q.y_ <- q.y_ / sum(q.y_)
