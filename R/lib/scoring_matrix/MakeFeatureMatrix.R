MakeFeatureMatrix <- function(s5 = NA, p = NA)
{
  
  dir <- getwd()
  cSymFile <- paste(dir, "lib/data/symbols/consonants", sep = "/")
  vSymFile <- "lib/data/symbols/vowels"
  
  cValFile <- "lib/data/features/consonants_values"
  vValFile <- "lib/data/features/vowels_values"
  
  ######
  # make consonant array
  consonant <- as.matrix(read.table(cSymFile))
  consonant_length <- length(consonant)
  
  # make vowel array
  vowel <- as.matrix(read.table(vSymFile))
  vowel_length <- length(vowel)
  
  # get the sum of length of consonant and vowel
  score_row <- score_col <- consonant_length + vowel_length + 1
  
  symbols <- c(consonant, vowel, "-")
  
  # assign s5 scores
  feature_matrix <- matrix(s5, nrow = score_row, ncol = score_col, 
                           dimnames = list(symbols, symbols))
  # assign gap penalty
  feature_matrix["-", ] <- p
  feature_matrix[, "-"] <- p
  feature_matrix["-", "-"] <- 0
    
  # consonant feature
  c_feature <- read.table(cValFile)
  k <- dim(c_feature)[[1]]
  l <- dim(c_feature)[[2]]
  
  c <- matrix(NA, k, l, dimnames = list(consonant, c()))
  for (i in 1:l) {
    c[, i] <- c_feature[, i]
  }

  c_match <- matrix(NA, k, k)
  for (i in 1:k) {
    for (j in 1:k) {
      match <- 0
      for (n in 1:5) {
        if (c[i, n] == c[j, n])
          match <- match + 1
      }
      c_match[i, j] <- match
    }
  }
  
  # vowel feature
  v_feature <- read.table(vValFile)
  k <- dim(v_feature)[[1]]
  l <- dim(v_feature)[[2]]
  
  v <- matrix(NA, k, l)
  for (i in 1:l) {
    v[, i] <- v_feature[, i]
  }
  
  v_match <- matrix(NA, k, k)
  for (i in 1:k) {
    for (j in 1:k) {
      match <- 0
      for (n in 1:5) {
        if (v[i, n] == v[j, n])
          match <- match + 1    
      }
      v_match[i, j] <- match
    }
  }
  
  ###
  feature_matrix[1:81, 1:81] <- c_match
  feature_matrix[82:118, 82:118] <- v_match
  
  return(feature_matrix)
}
