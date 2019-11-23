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
