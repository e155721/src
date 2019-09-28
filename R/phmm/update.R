source("phmm/initialization.R")
source("phmm/forward.R")
source("phmm/backward.R")
source("phmm/xi.R")
source("phmm/gamma.R")

L.new <- 0
h <- 1
L.vec <- c()
while (1) {
  print(h)
  h <- h + 1
  
  # for each word
  fb <- list()
  fb$forward <- Forward(O, params, E)
  fb$backward <- Backward(O, params, E)
  params <- ExeXi(O, fb, A, E)
  
  if (L.new == 0) {
    L.new <- CalcL(O, fb)
  } else {
    L <- L.new
    L.new <- CalcL(O, fb)
    L.vec <- append(L.vec, L.new)
    if (L.new == L) {
      break
    }
  }
  
  A <- Assign2A(params, S)
  pi <- matrix(c(1 - 2 * params["delta"] - params["tau.M"], params["delta"], params["delta"]), 1, length(S))  # initial probability
  dimnames(pi) <- list(NULL, S)
  E <- ExeGamma(O, fb)
  
}
