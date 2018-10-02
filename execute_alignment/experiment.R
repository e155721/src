.myfunc.env <- new.env()
sys.source("../src/data_processing/getFeaturesScore.R", envir = .myfunc.env)
attach(.myfunc.env)

score_symbols <- getFeaturesScore()
scoring_matrix <- makeScoringMatrix(s5 = -4)
d <- dim(scoring_matrix)[1]

# ex1 (rejection)
for (i in 1:d) {
  scoring_matrix[i, ] <- scoring_matrix[i, ] + score_symbols[i]
  scoring_matrix[, i] <- scoring_matrix[, i] + score_symbols[i]
}

# ex2 (rejection)
match <- diag(scoring_matrix)
consonant_mismatch <- scoring_matrix[1:81, 1:81]
vowel_mismatch <- scoring_matrix[82:118, 82:118]
cv_mismatch <- scoring_matrix[1:81, 82:118]
vc_mismatch <- scoring_matrix[82:118, 1:81]

scoring_matrix[1:81, 1:81] <- consonant_mismatch * -1
scoring_matrix[82:118, 82:118] <- vowel_mismatch * -1
scoring_matrix[1:81, 82:118] <- cv_mismatch * -1
scoring_matrix[82:118, 1:81] <- vc_mismatch * -1
diag(scoring_matrix) <- match

# ex3
score_symbols <- getFeaturesScore()
scoring_matrix <- makeScoringMatrix(s5 = -4)
diag(scoring_matrix) <- diag(scoring_matrix) + score_symbols

# ex4
score_symbols <- getFeaturesScore()
scoring_matrix <- makeScoringMatrix(s5 = -4)
d <- dim(scoring_matrix)[1]

for (i in 1:d) {
  scoring_matrix[i, ] <- scoring_matrix[i, ] + score_symbols[i]
  scoring_matrix[, i] <- scoring_matrix[, i] + score_symbols[i]
}

match <- diag(scoring_matrix)
consonant_mismatch <- scoring_matrix[1:81, 1:81]
vowel_mismatch <- scoring_matrix[82:118, 82:118]

scoring_matrix <- makeScoringMatrix(s5 = -4)
scoring_matrix[1:81, 1:81] <- consonant_mismatch
scoring_matrix[82:118, 82:118] <- vowel_mismatch
diag(scoring_matrix) <- match
