# make scoring matrix of alphabets
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

write.table(scoringMatrix, "scoring_matrix_for_alphabets.txt")

# make scoring matrix of "kubi"
dimnames <- c("k", "kx", "kh", "u", "b", "p", "d", "i", "i:")
len <- length(dimnames)
scoringMatrix <- matrix(-1, nrow = len, ncol = len,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- -1
