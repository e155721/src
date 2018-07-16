library(Biostrings)

# make a matrix that it all elements are -1 and it diagonals are 0
vowel <- scan("vowel.txt", character(), quote = "")
consonant <- scan("consonant.txt", character(), quote = "")

symbols <- c(vowel, consonant)
sl <- length(symbols)

len <- length(symbols)
newSymbols <- c()
newInd <- 1
for (i in 1:len) {
  if (nchar(symbols[i]) == 1) {
    newSymbols[newInd] <- symbols[i]
    newInd <- newInd+1
  }
}
