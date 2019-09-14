library(MCMCpack)
library(gtools)

source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")

wl <- MakeWordList("../../Alignment/org_data/01-003首(2-2).org")
wl <- MakeGoldStandard(wl)
wl <- MakeInputSeq(wl)

wl.o <- list()
len <- length(wl)
j <- 1
for (i in 1:len) {
  if (!is.null(wl[[i]])) {
    wl.o[[j]] <- wl[[i]]
    j <- j + 1
  }
}

O1 <- append(wl.o[[1]], NA)
O2 <- append(wl.o[[2]], NA)

# Removes the gaps and the valujes of NA from the two observation sequences.
Sig <- unique(as.vector(list2mat(wl.o)[, -1]))
Sig <- Sig[Sig!=" "]

S <- c("M","X","Y","End")  # set of states
N <- length(S)  # number of emission states
M <- length(Sig)  # number of emission symbols

# Initializes matrix which is symbol pairs emission probability.
p.xy <- matrix(rdirichlet(1, matrix(1,1,M*M)), M, M, dimnames = list(Sig, Sig))
q.x <- as.vector(rdirichlet(1, matrix(1,1,M)))
q.y <- as.vector(rdirichlet(1, matrix(1,1,M)))

names(q.x) <- Sig
names(q.y) <- Sig

# transition proboility
params <- as.vector(rdirichlet(1, matrix(1,1,5)))
names(params) <- c("delta", "epsilon", "lambda", "tau.XY", "tau.M")

A <- matrix(NA, N, N, dimnames = list(S, S))
A["M", "M"] <- 1-2*params["delta"]-params["tau.M"]
A["M", "X"] <- A["M", "Y"] <- params["delta"]
A["M", "End"] <- params["tau.M"]

A["X", "X"] <- A["Y", "Y"] <- params["epsilon"]
A["X", "Y"] <- A["Y", "X"] <- params["lambda"]
A["X", "End"] <- A["Y", "End"] <- params["tau.XY"]
A["X", "M"] <- A["Y", "M"] <- 1-params["epsilon"]-params["lambda"]-params["tau.XY"]

A["End", ] <- 0

pi <- c(1-2*params["delta"]-params["tau.M"], params["delta"], params["delta"], 0)  # initial probability
names(pi) <- S
