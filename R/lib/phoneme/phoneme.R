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
    feat.mat[, j] <- gsub(pattern = "*[ ]*", replacement = "", feat.mat[, j])
  }

  feat.mat
}

get_phone_info <- function(cons_file, vowel_file) {

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
    mat.C.feat[, j] <- paste(j, "C", mat.C.feat[, j], sep = "")
    mat.V.feat[, j] <- paste(j, "V", mat.V.feat[, j], sep = "")
  }

  C.feat <- unique(as.vector(mat.C.feat))
  V.feat <- unique(as.vector(mat.V.feat))

  CV <- c(C, V)
  mat.CV.feat <- rbind(mat.C.feat, mat.V.feat)
  CV.feat <- c(C.feat, V.feat)
  feat.num <- dim(mat.CV.feat)[2]

  # Make global variables.
  assign(x = "feat.num", value = feat.num, envir = .GlobalEnv)

  assign(x = "C", value = C, envir = .GlobalEnv)
  assign(x = "V", value = V, envir = .GlobalEnv)
  assign(x = "CV", value = CV, envir = .GlobalEnv)

  assign(x = "mat.C.feat", value = mat.C.feat, envir = .GlobalEnv)
  assign(x = "mat.V.feat", value = mat.V.feat, envir = .GlobalEnv)
  assign(x = "mat.CV.feat", value = mat.CV.feat, envir = .GlobalEnv)
}

cons_file  <- "lib/phoneme/features/consonants.txt"
vowel_file <- "lib/phoneme/features/vowels.txt"
get_phone_info(cons_file, vowel_file)
