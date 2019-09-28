source("phmm/initialization.R")
source("phmm/forward.R")
source("phmm/backward.R")
source("phmm/xi.R")

# for each word
fb <- list()
fb$forward <- Forward(O, params, E)
fb$backward <- Backward(O, params, E)
params <- ExeXi(O, fb, A, E)

A <- Assign2A(params, S)
pi <- matrix(c(1 - 2 * params["delta"] - params["tau.M"], params["delta"], params["delta"]), 1, length(S))  # initial probability
dimnames(pi) <- list(NULL, S)

E <- ExeGamma(O, fb)
