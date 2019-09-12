A.h <- matrix(0, N+1, N+1, dimnames = list(S, S))

delta.h <- 0
epsilon.h <- 0
lambda.h <- 0

I <- c("M", "X", "X")
J <- c("X", "X", "Y")

for (s in 1:N) {
  
  i <- I[s]
  j <- J[s]
  
  print(paste(i, j))
  
  if (j=="M") {
    U.h <- U-1
    V.h <- V-1
  }
  else if (j=="X") {
    U.h <- U-1
    V.h <- V
  } else {
    U.h <- U
    V.h <- V-1
  }
  
  for (u in 2:U.h) {
    for (v in 2:V.h) {
      if (i=="M" && j=="X") {
        # a.ij <- a.ij + Xi.uv(u, v, i, j, list.f, list.b, A)
        delta.h <- delta.h + Xi.uv(u, v, i, j, list.f, list.b, A)
      }
      else if (i=="X" && j=="X") {
        epsilon.h <- epsilon.h + Xi.uv(u, v, i, j, list.f, list.b, A)
      }
      else if (i=="X" && j=="Y") {
        lambda.h <- lambda.h + Xi.uv(u, v, i, j, list.f, list.b, A)
      }
    }
  }
}

tau.M.h <- 1-2*delta.h
tau.XY.h <- 1-epsilon.h-lambda.h

A.h["M", "End"] <- 1-2*delta.h
A.h["M", "M"] <- 1-2*delta.h-tau.M.h
A.h["M", "X"] <- A.h["M", "Y"] <- delta.h

A.h["X", "X"] <- A.h["Y", "Y"] <- epsilon.h
A.h["X", "Y"] <- A.h["Y", "X"] <- lambda.h
A.h["X", "End"] <- A.h["Y", "End"] <- 1-epsilon.h-lambda.h
A.h["X", "M"] <- A.h["Y", "M"] <- 1-epsilon.h-lambda.h-tau.XY.h

A.h["End", ] <- 0
