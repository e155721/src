library(MCMCpack)
library(tictoc)

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# Alpha
alpha <- function(t, j, A, B, O)
{
  N <- dim(A)[1]
  at <- 0
  if (t == 1) {
    return(pi[j]*B[j, O[1]])
  } else {
    for (i in 1:N) {
      at <- at + alpha((t-1), i, A, B, O)*A[i, j]
    }
    at <- at * B[j, O[t]]
  }
  
  if (is.na(at)) {
    return(0)
  } else {
    return(at)
  }
}

# Beta
beta <- function(t, i, A, B, O)
{
  N <- dim(A)[1]
  bt <- 0
  if (t == T) {
    return(1)
  } else {
    for (j in 1:N) {
      bt <- bt + A[i, j]*B[j, O[t+1]]*beta((t+1), j, A, B, O)
    }
  }
  
  if (is.na(bt)) {
    return(0)
  } else {
    return(bt)
  }
}

# Gamma
gamma <- function(t, i, Al)
{
  return(alpha(t, i, A, B, O)*beta(t, i, A, B, O)/Al)
}

# Epsilon
epsilon <- function(t, i, j, A, B, O, Al)
{
  return(alpha(t, i, A, B, O)*A[i, j]*B[j, O[t+1]]*beta((t+1), j, A, B, O)/Al)
}

# Updating A
UpdateA <- function(T, i, j, A, B, O, Al)
{
  num <- 0
  den <- 0
  for (t in 1:(T-1)) {
    num <- num + epsilon(t, i, j, A, B, O, Al)
    den <- den + gamma(t, i, Al)
  }
  a <- num/den
  if (is.na(a)) {
    return(0)
  } else {
    return(a)
  }
}

# Delta
delta <- function(t, k, O, S)
{
  if (O[t] == S[k]) {
    return(1)
  } else {
    return(0)
  }
}

# Updating B
UpdateB <- function(T, j, k, A, B, O, Al)
{
  num <- 0
  den <- 0
  for (t in 1:T) {
    num <- num + delta(t, k, O, S)*gamma(t, j, Al)
    den <- den + gamma(t, j, Al)
  }
  b <- num/den
  if (is.na(b)) {
    return(0)
  } else {
    return(num/den)
  }
}

# input
N <- 4
S <- c(1,2,3)
set.seed(101)
O <- sample(S, 5, replace = TRUE, prob = c(.54, .21, .25))

# number of states
T <- length(O)
# number of symbols
K <- length(S)

# making initializing probabirity
pi <- rdirichlet(1, matrix(1,1,N))

# making transition matrix
A <- matrix(NA, N, N)
for (i in 1:N) {
  A[i, ] <- rdirichlet(1, matrix(1,1,N))
}

# making emission probabirity
B <- matrix(NA, N, K)
for (i in 1:N) {
  B[i, ] <- rdirichlet(1, matrix(1,1,K))
}
colnames(B) <- S

# Baum-Welch
loop <- 0
Al_vec <- c(NULL)
tic()
while (1) {
  loop <- loop+1
  
  # calculating alpha
  Al <- 0
  for (i in 1:N) {
    Al <- Al + alpha(T, i, A, B, O)
  }
  
  # calculating beta
  if (0) {
    Be <- 0
    for (i in 1:N) {
      Be <- Be + pi[i]*B[i, O[1]]*beta(1, i, A, B,)
    }
  }
  
  # update A
  for (i in 1:N) {
    for (j in 1:N) {
      A[i, j] <- UpdateA(T, i, j, A, B, O, Al)
    }
  }
  
  # update B
  for (j in 1:N) {
    for (k in 1:K) {
      B[j, k] <- UpdateB(T, j, k, A, B, O, Al)
    }
  }
  
  # update pi
  for (i in 1:N) {
    pi[i] <- gamma(1, i, Al)
  }
  
  for (i in 1:N) {
    sum.a <- sum(A[i, ])
    if (sum.a == 0) {
      A[i, ] <- 0
    } else {
      A[i, ] <- A[i, ]/sum.a
    }
    
    sum.b <- sum(B[i, ])
    if (sum.b == 0) {
      B[i, ] <- 0
    } else {
      B[i, ] <- B[i, ]/sum.b
    }
  }
  pi <- pi/sum(pi)
  
  if (loop>2) {
    if (Al==Al.old) {
      break  
    } 
    else if (abs((Al-Al.old))<=0.0000001) {
      break
    }
  }
  Al.old <- Al
  Al_vec <- append(Al_vec, Al)
  print(Al)  
}
toc()

s <- list(Al, Al_vec, A, B, pi)
names(s) <- c("Al", "Al_vec", "A", "B", "pi")
save(s, file = "result")
