# Consonants
C <- as.vector(read.table("lib/phoneme/symbols/consonants.txt")[, 1])

# Vowels
V <- as.vector(read.table("lib/phoneme/symbols/vowels.txt")[, 1])

# Consonant features
C.feat <- as.matrix(read.table("lib/phoneme/features/consonants.txt"))
dimnames(C.feat) <- list(C, NULL)

# Vowel features
V.feat <- as.matrix(read.table("lib/phoneme/features/vowels.txt"))
dimnames(V.feat) <- list(V, NULL)

for (j in 1:5) {
  C.feat[, j] <- paste("C", C.feat[, j], j, sep="")
  V.feat[, j] <- paste("V", V.feat[, j], j, sep="")
}
CV.feat <- rbind(C.feat, V.feat)
dimnames(CV.feat) <- list(c(C, V), NULL)