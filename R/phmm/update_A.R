f.var <- Forward(O1, O2, params)
b.var <- Backward(O1, O2, params)

params <- ExeXi(u, v, i, j, O1, O2, f.var, b.var, A)

A <- Assign2A(params, S)
pi <- c(1-2*params["delta"]-params["tau.M"], params["delta"], params["delta"], 0)
