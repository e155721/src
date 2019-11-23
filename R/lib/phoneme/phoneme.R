# Consonants
C <- as.vector(read.table("lib/phoneme/symbols/consonants.txt")[, 1])

# Vowels
V <- as.vector(read.table("lib/phoneme/symbols/vowels.txt")[, 1])

# Consonant features
mat.C.feat <- as.matrix(read.table("lib/phoneme/features/consonants.txt"))
dimnames(mat.C.feat) <- list(C, NULL)

# Vowel features
mat.V.feat <- as.matrix(read.table("lib/phoneme/features/vowels.txt"))
dimnames(mat.V.feat) <- list(V, NULL)

for (j in 1:5) {
  mat.C.feat[, j] <- paste("C", mat.C.feat[, j], j, sep="")
  mat.V.feat[, j] <- paste("V", mat.V.feat[, j], j, sep="")
}

C.feat <- unique(as.vector(mat.C.feat))
V.feat <- unique(as.vector(mat.V.feat))
