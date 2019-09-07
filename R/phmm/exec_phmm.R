Q <- c("M","X","Y","End")  # set of states
N <- length(Q)  # number of states
S <- c("A", "B", "C", "-")  # set of emission symbols
K <- length(S)  # number of emission symbols
S.pair <- t(permutations(n=K, r=2, v=S, repeats.allowed = T))  # set of emission symbol pairs
K.pair <- dim(S.pair)[2]  # number of emission symbol pairs.

# transition proboility
A <- matrix(0, N, N)
dimnames(A) <- list(Q, Q)
par.vec <- rdirichlet(1, matrix(1,1,5))
epsilon <- par.vec[1]
lambda <- par.vec[2]
delta <- par.vec[3]
tau.xy <- par.vec[4]
tau.m <- par.vec[5]

pi <- c(1-2*delta-tau.m, delta, delta)  # initial proboility

# M
A["M", "M"] <- 1-2*delta-tau.m
A["M", "X"] <- delta
A["M", "Y"] <- delta
A["M", "End"] <- tau.m
# X
A["X", "X"] <- epsilon
A["X", "M"] <- 1-epsilon-lambda-tau.xy
A["X", "Y"] <- lambda
A["X", "End"] <- tau.xy
# Y
A["Y", "Y"] <- epsilon
A["Y", "M"] <- 1-epsilon-lambda-tau.xy
A["Y", "X"] <- lambda
A["Y", "End"] <- tau.xy
# End
A["End", ] <- 0

B <- matrix(0, N, K.pair)  # matrix of emission probability
dimnames(B) <- list(Q)

# Initializes the emission probability in the state M.
M.tmp <- S.pair == "-"
M.vec <- M.tmp[1, ] + M.tmp[2, ]
M.ind <- grep(0, M.vec)
K.m <- length(M.ind)
B["M", M.ind] <- rdirichlet(1, matrix(1,1,K.m))

# Initializes the emission probability in the state X.
X.vec <- as.numeric(S.pair[1, ] == "-")
X.ind <- grep(0, X.vec)
K.x <- length(X.ind)
B["X", X.ind] <- rdirichlet(1, matrix(1,1,K.x))

# Initializes the emission probability in the state Y.
Y.vec <- as.numeric(S.pair[2, ] == "-")
Y.ind <- grep(0, Y.vec)
K.y <- length(Y.ind)
B["Y", Y.ind] <- rdirichlet(1, matrix(1,1,K.y))

FT <- 100  # final time
PHMM(pi, Q, S.pair, A, B, FT)  # execution phmm
