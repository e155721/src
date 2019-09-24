source("phmm/initialization.R")
source("phmm/forward.R")
source("phmm/backward.R")
source("phmm/xi.R")

f.var <- Forward(O1, O2, params, E)
b.var <- Backward(O1, O2, params, E)

params <- ExeXi(O1, O2, f.var, b.var, A, E)

A <- Assign2A(params, S)
pi <- matrix(c(1 - 2 * params["delta"] - params["tau.M"], params["delta"], params["delta"]), 1, length(S))  # initial probability
dimnames(pi) <- list(NULL, S)
