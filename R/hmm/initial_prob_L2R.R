# initial probability
pi <- c(1.0, 0.0, 0.0, 0.0)
# number of states
N <- 4
# output series
O <- c(1,1,2,3)
# final time
T <- length(O)
S <- c(1,2,3)
K <- length(S)

# A: transition probability
A <- matrix(0, N, N)
A[1,1] <- 0.7
A[1,2] <- 0.3
A[2,2] <- 0.6
A[2,3] <- 0.4
A[3,3] <- 0.1
A[3,4] <- 0.9

# B: output probability
B <- matrix(0, N, K)
B[1,1] <- 0.7
B[1,2] <- 0.2
B[1,3] <- 0.1
B[2,1] <- 0.4
B[2,2] <- 0.3
B[2,3] <- 0.3
B[3,1] <- 0.1
B[3,2] <- 0.1
B[3,3] <- 0.8
