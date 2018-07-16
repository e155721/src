# make scoring matrix for alphabets
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

write.table(scoringMatrix, "scoring_matrix_for_alphabets.txt")
