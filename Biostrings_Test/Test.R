library(Biostrings)

# make a matrix that it all elements are -1 and it diagonals are 0
submat <- matrix(-1, nrow = 26, ncol = 26, dimnames = list(letters, letters))
diag(submat) <- 3

firstSequence = c("agac")
secondSequence = "agcg"
pairwiseAlignment(pattern = firstSequence, subject = secondSequence, 
                  substitutionMatrix = submat, gapOpening = 0, gapExtension = 2)
