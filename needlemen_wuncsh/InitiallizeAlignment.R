scoringMatrix <- read.table("scoring_matrix_for_alphabets.txt")

# this code defines gap penalty
p <- -2

# these codes receive input sequences
seq1 <- c("A", "G", "C", "G")
seq2 <- c("A", "G", "A", "C")

seq1 <- append(seq1, NA, after = 0)
seq2 <- append(seq2, NA, after = 0)
