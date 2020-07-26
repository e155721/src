make_phone_vec <- function(file) {
  vec <- read.table(file, fileEncoding = "utf-8")[, 1]
  vec <- as.vector(vec)  # for gpu
  vec
}

make_feat_mat <- function(file) {
  feat.mat <- read.table(file, fileEncoding = "utf-8")
  feat.mat <- as.matrix(feat.mat)
  dimnames(feat.mat) <- list(feat.mat[, 1], NULL)
  feat.mat <- feat.mat[, -1, drop = F]
  
  N <- dim(feat.mat)[2]
  for (j in 1:N) {
    feat.mat[, j] <- as.numeric(feat.mat[, j])
  }
  
  feat.mat
}

cons_file  <- "lib/phoneme/features/consonants.txt"
vowel_file <- "lib/phoneme/features/vowels.txt"

# Consonants
C <- make_phone_vec(cons_file)

# Vowels
V <- make_phone_vec(vowel_file)

# Consonant features
mat.C.feat <- make_feat_mat(cons_file)

# Vowel features
mat.V.feat <- make_feat_mat(vowel_file)

N <- dim(mat.C.feat)[2]
for (j in 1:N) {
  mat.C.feat[, j] <- paste(j, "C", mat.C.feat[, j], sep="")
}

N <- dim(mat.V.feat)[2]
for (j in 1:N) {
  mat.V.feat[, j] <- paste(j, "V", mat.V.feat[, j], sep="")
}

C.feat <- unique(as.vector(mat.C.feat))
V.feat <- unique(as.vector(mat.V.feat))

CV <- c(C, V)
mat.CV.feat <- rbind(mat.C.feat, mat.V.feat)
CV.feat <- c(C.feat, V.feat)
feat.num <- dim(mat.CV.feat)[2]
