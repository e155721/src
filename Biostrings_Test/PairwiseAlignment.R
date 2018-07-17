library(Biostrings)

# make a matrix that it all elements are -1 and it diagonals are 0
vowel <- scan("vowel.txt", character(), quote = "")
consonant <- scan("consonant.txt", character(), quote = "")

symbols <- c(vowel, consonant)
sl <- length(symbols)

submat <- matrix(-1, nrow = sl, ncol = sl, dimnames = list(symbols, symbols))
diag(submat) <- 0

firstSequence = c("i2")
secondSequence = "ai"
pairwiseAlignment(pattern = firstSequence, subject = secondSequence, 
                  substitutionMatrix = submat, gapOpening = 0, gapExtension = 1)
