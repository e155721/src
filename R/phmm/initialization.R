library(MCMCpack)
library(gtools)

# O1 <- c(NA, "k", "u", "b")
# O2 <- c(NA, "k", "u", "b", "i")

n <- length(O1)
m <- length(O2)

# Removes the gaps and the valujes of NA from the two observation sequences.
Sig <- unique(append(O1[-1], O2[-1]))
gap <- grep("-", Sig)
if (sum(gap) != 0) {
  Sig <- Sig[-gap]  # removing gaps
}

S <- c("M","X","Y","End")  # set of states
N <- 3  # number of emission states
M <- length(Sig)  # number of emission symbols

# Initializes matrix which is symbol pairs emission probability.
p.xy <- matrix(rdirichlet(1, matrix(1,1,M*M)), M, M, dimnames = list(Sig, Sig))
q.x <- as.vector(rdirichlet(1, matrix(1,1,M)))
q.y <- as.vector(rdirichlet(1, matrix(1,1,M)))

names(q.x) <- Sig
names(q.y) <- Sig

# transition proboility
parameters <- rdirichlet(1, matrix(1,1,5))
epsilon <- parameters[1]
lambda <- parameters[2]
delta <- parameters[3]
tau.XY <- parameters[4]
tau.M <- parameters[5]

A <- matrix(NA, N+1, N+1, dimnames = list(S, S))
A["M", "M"] <- 1-2*delta-tau.M
A["M", "X"] <- A["M", "Y"] <- delta
A["M", "End"] <- tau.M

A["X", "X"] <- A["Y", "Y"] <- epsilon
A["X", "Y"] <- A["Y", "X"] <- lambda
A["X", "End"] <- A["Y", "End"] <- tau.XY
A["X", "M"] <- A["Y", "M"] <- 1-epsilon-lambda-tau.XY
A["End", ] <- 0

pi <- c(1-2*delta-tau.M, delta, delta, 0)  # initial probability
names(pi) <- S
