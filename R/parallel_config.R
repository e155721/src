library(doMC)

cores <- detectCores() / 2
registerDoMC(cores)
