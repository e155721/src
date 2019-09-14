f.var <- Forward(O1, O2, params)
b.var <- Backward(O1, O2, params)

params <- ExeXi(u, v, i, j, O1, O2, f.var, b.var, A)

A["M", "M"] <- 1-2*params["delta"]-params["tau.M"]
A["M", "X"] <- A["M", "Y"] <- params["delta"]
A["M", "End"] <- params["tau.M"]

A["X", "X"] <- A["Y", "Y"] <- params["epsilon"]
A["X", "Y"] <- A["Y", "X"] <- params["lambda"]
A["X", "End"] <- A["Y", "End"] <- params["tau.XY"]
A["X", "M"] <- A["Y", "M"] <- 1-params["epsilon"]-params["lambda"]-params["tau.XY"]

A["End", ] <- 0

pi <- c(1-2*params["delta"]-params["tau.M"], params["delta"], params["delta"], 0)
