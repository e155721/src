A_ <- matrix(0, N+1, N+1, dimnames = list(S, S))

U <- length(O1) - 1
V <- length(O2) - 1

num <- 0
den <- 0

I <- c("M", "X", "X")
J <- c("X", "X", "Y")

for (s in 1:N) {
  
  i <- I[s]
  j <- J[s]
  
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
      num <- num + Xi(u, v, i, j, O1, O2, f.var, b.var, A)
    }
  }
  
  
  if (1) {
    for (u in 2:U.h) {
      for (v in 2:V.h) {
        for (j_ in J) {
          den <- den + Xi(u, v, i, j_, O1, O2, f.var, b.var, A)
        }
      }
    }
  }
  
  a.ij_ <- num / den
  if (is.na(a.ij_)) {
    a.ij_ <- 0
  } 
  else if (is.infinite(a.ij_)) {
    a.ij_<- 0
  } else {
    # no operation
  }
  
  if (i=="M" && j=="X") {
    delta_ <- a.ij_
  }
  else if (i=="X" && j=="X") {
    epsilon_ <- a.ij_
  }
  else if (i=="X" && j=="Y") {
    lambda_ <- a.ij_
  }
  
}

tau.M_ <- 1-2*delta_
tau.XY_ <- 1-epsilon_-lambda_

A_["M", "M"] <- 1-2*delta_-tau.M_
A_["M", "X"] <- A_["M", "Y"] <- delta_
A_["M", "End"] <- tau.M_

A_["X", "X"] <- A_["Y", "Y"] <- epsilon_
A_["X", "Y"] <- A_["Y", "X"] <- lambda_
A_["X", "End"] <- A_["Y", "End"] <- 1-epsilon_-lambda_
A_["X", "M"] <- A_["Y", "M"] <- 1-epsilon_-lambda_-tau.XY_

A_["End", ] <- 0

params$epsilon <- epsilon_
params$lambda <- lambda_
params$delta <- delta_
params$tau.XY <- tau.XY_
params$tau.M <- tau.M_

pi <- c(1-2*params$delta-params$tau.M, params$delta, params$delta, 0)
A <- A_
