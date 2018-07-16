# these codes make scoring matrix
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

# this code defines gap penalty
p <- -2

# these codes receive input sequences
seq1 <- c(NA, "A", "G", "C", "G")
seq2 <- c(NA, "A", "G", "A", "C")
