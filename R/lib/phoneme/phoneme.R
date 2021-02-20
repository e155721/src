make_phone_vec <- function(feat.mat) {
  vec <- dimnames(feat.mat)[[1]]
  vec <- vec[-which(vec == "-")]  # removing the gap symbols
  vec
}

make_feat_mat <- function(file) {
  feat.mat <- read.table(file, fileEncoding = "utf-8")
  feat.mat <- as.matrix(feat.mat)

  N <- dim(feat.mat)[2]
  for (j in 1:N) {
    feat.mat[, j] <- gsub(pattern = "*[ ]*", replacement = "", feat.mat[, j])
  }
  gap <- matrix(rep("0", N), 1, N, dimnames = list("-"))
  feat.mat <- rbind(feat.mat, gap)

  feat.mat
}

get_phone_info <- function(cons_file, vowel_file) {

  # Consonant features
  mat.C.feat <- make_feat_mat(cons_file)

  # Vowel features
  mat.V.feat <- make_feat_mat(vowel_file)

  # Consonants
  C <- make_phone_vec(mat.C.feat)

  # Vowels
  V <- make_phone_vec(mat.V.feat)

  N.cons <- dim(mat.C.feat)[2]
  for (j in 1:N.cons) {
    mat.C.feat[, j] <- paste(j, "C", mat.C.feat[, j], sep = "")
  }

  N.vowel <- dim(mat.V.feat)[2]
  for (j in 1:N.vowel) {
    mat.V.feat[, j] <- paste(j, "V", mat.V.feat[, j], sep = "")
  }

  if (N.cons == N.vowel) {

    mat.CV.feat <- rbind(make_feat_mat(cons_file), make_feat_mat(vowel_file))
    CV <- c(C, V)

    for (j in 1:N.cons) {
      mat.CV.feat[, j] <- paste(j, "CV", mat.CV.feat[, j], sep = "")
    }

    assign(x = "CV", value = CV, envir = .GlobalEnv)
    assign(x = "mat.CV.feat", value = mat.CV.feat, envir = .GlobalEnv)

  }

  # Make global variables.
  assign(x = "C", value = C, envir = .GlobalEnv)
  assign(x = "V", value = V, envir = .GlobalEnv)

  assign(x = "mat.C.feat", value = mat.C.feat, envir = .GlobalEnv)
  assign(x = "mat.V.feat", value = mat.V.feat, envir = .GlobalEnv)
}

cons_file  <- "lib/phoneme/features/consonants.txt"
vowel_file <- "lib/phoneme/features/vowels.txt"
get_phone_info(cons_file, vowel_file)
