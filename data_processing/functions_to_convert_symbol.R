# make consonant array
consonant <- as.matrix(read.table("symbols/consonant.txt"))
consonant_length <- length(consonant)
new_consonant <- array("V", dim = consonant_length)

# make vowel array
vowel <- as.matrix(read.table("symbols/vowel.txt"))
vowel_length <- length(vowel)
new_vowel <- array("C", dim = vowel_length)

# get the sum of length of consonant and vowel
array_length <- vowel_length + consonant_length

# make new_symbols_array
new_symbols_array <- array(NA, dim = array_length,
                           dimnames = list(c(consonant, vowel)))
new_symbols_array[1:array_length] <- c(new_consonant, new_vowel)

# make new scoring matrix
scoring_matrix <- matrix(-3, 2, 2, 
                         dimnames = list(c("C", "V"), c("C", "V")))
diag(scoring_matrix) <- 1

# convert original symbols to consonant or vowel symbols
toCorV <- function(seq)
{
  # return a list of length 2
  seq_length <- length(seq)
  org_array <- array()
  for (i in 1:seq_length) {
    org_array[i] <- seq[i] 
    seq[i] <- new_symbols_array[seq[i]]
  }
  
  rlt <- list(NA, NA)
  names(rlt) <- c("sym", "org")
  rlt[["sym"]] <- seq
  rlt[["org"]] <- org_array
  return(rlt)
}

# convert consonant or vowel symbols to original symbols
toOrg <- function(seq, to_org_array)
{
  # return a character vector
  org_array <- to_org_array
  for (i in grep("_", seq)) {
    org_array <- append(org_array, "_", after = i-1)
  }
  return(org_array)
}