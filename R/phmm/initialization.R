library(MCMCpack)
library(gtools)

source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")

Asign2A <- function(params, S) {
  # Assignes the parameters to the matrix.
  #
  # Args:
  #   params: The transition parameters.
  #   S: The set of emission states.
  #
  # Returns:
  #   The transition matrix.
  delta <- params["delta"]
  epsilon <- params["epsilon"]
  lambda <- params["lambda"]
  tau.M <- params["tau.M"]
  tau.XY <- params["tau.XY"]
  m.m <- 1-2*delta-tau.M
  xy.m <- 1-epsilon-lambda-tau.XY

  N <- length(S) + 1  # number of emission states and a silent state
  S <- append(S, "End")
  A <- matrix(0, N, N, dimnames = list(S, S))
  A["M", "M"] <- m.m
  A["M", "X"] <- A["M", "Y"] <- delta
  A["M", "End"] <- tau.M

  A["X", "X"] <- A["Y", "Y"] <- epsilon
  A["X", "Y"] <- A["Y", "X"] <- lambda
  A["X", "End"] <- A["Y", "End"] <- tau.XY
  A["X", "M"] <- A["Y", "M"] <- xy.m

  return(A)
}

Assign2E <- function(Sig) {

  M <- length(Sig)

  # Initializes matrix which is symbol pairs emission probability.
  p.xy <- matrix(rdirichlet(1, matrix(1,1,M*M)), M, M, dimnames = list(Sig, Sig))
  q.x <- matrix(rdirichlet(1, matrix(1,1,M)), 1, M, dimnames = list("-", Sig))
  q.y <- matrix(rdirichlet(1, matrix(1,1,M)), 1, M, dimnames = list("-", Sig))

  E <- list(p.xy, q.x, q.y)
  names(E) <- c("M", "X", "Y")

  return(E)
}

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

U <- length(O1) - 2
V <- length(O2) - 2

O <- list(O1, O2, U, V)
names(O) <- c("O1", "O2", "U", "V")

# Removes the gaps and the valujes of NA from the two observation sequences.
Sig <- unique(as.vector(list2mat(wl.o)[, -1]))
Sig <- Sig[Sig != " "]

S <- c("M","X","Y")  # set of emission states
N <- length(S)  # number of emission states
M <- length(Sig)  # number of emission symbols

# transition proboility
params.name <- c("delta", "tau.M", "epsilon", "lambda", "tau.XY")
params1 <- as.vector(rdirichlet(1, matrix(1,1,3)))[2:3]
params2 <- as.vector(rdirichlet(1, matrix(1,1,4)))[2:4]

params <- c(params1, params2)
names(params) <- params.name
params["delta"] <- params["delta"] / 2

A <- Assign2A(params, S)
E <- Assign2E(Sig)

pi <- matrix(c(1 - 2 * params["delta"] - params["tau.M"], params["delta"], params["delta"]), 1, length(S))  # initial probability
dimnames(pi) <- list(NULL, S)
