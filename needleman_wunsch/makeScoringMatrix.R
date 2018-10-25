# define score
# s1 match between consonant to consonant
# s2 match between vowel to vowel
# s3 mismatch between consonant to consonant
# s4 mismatch between vowel to vowel
# s5 mismatch between consonant to vowel

MakeScoringMatrix <- function(s1 = 1, s2 = 1, s3 = -1, s4 = -1, s5 = -3)
{
  # make consonant array
  consonant <- as.matrix(read.table("symbols/consonant.txt"))
  consonant_length <- length(consonant)
  
  # make vowel array
  vowel <- as.matrix(read.table("symbols/vowel.txt"))
  vowel_length <- length(vowel)
  
  # get the sum of length of consonant and vowel
  score_row <- score_col <- consonant_length + vowel_length
  
  symbols <- c(consonant, vowel)
  
  scoring_matrix <- matrix(s5, nrow = score_row, ncol = score_col, 
                           dimnames = list(symbols, symbols))
  
  # mismatch between consonant to consonant
  for (i in 1:81) {
    for (j in 1:81) {
      scoring_matrix[i, j] <- s3
    }
  }
  
  # mismatch between vowel to vowel
  for (i in 82:118) {
    for (j in 82:118) {
      scoring_matrix[i, j] <- s4
    }
  }
  
  diag_consonant <- 1:81
  diag_vowel <- 82:118
  diag(scoring_matrix[diag_consonant, diag_consonant]) <- s1
  diag(scoring_matrix[diag_vowel, diag_vowel]) <- s2
  
  return(scoring_matrix)
}
