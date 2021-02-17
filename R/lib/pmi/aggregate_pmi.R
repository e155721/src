aggregate_pmi <- function(pmi_list, sound) {
  # Create the PMI matrix.
  #
  # Args:
  #   s: a scoring matrix
  #   pmi_list: a list of the PMIs for each segment pair.
  #
  # Return:
  #   the matrix of the PMIs.
  print("AggrtPMI")

  switch(sound,
         "C" = X <- C,
         "V" = X <- V,
         "CV" = X <- CV
  )

  switch(sound,
         "C" = mat.X.feat <- mat.C.feat,
         "V" = mat.X.feat <- mat.V.feat,
         "CV" = mat.X.feat <- mat.CV.feat
  )

  # The three-dimensional array to save the PF-PMI for each symbol pairs.
  N <- length(X) + 1
  feat_num <- dim(mat.X.feat)[2]
  pmi_mat <- array(NA, dim = c(N, N, feat_num), dimnames = list(c(X, "-"), c(X, "-")))

  seg.pair.num <- length(pmi_list)
  for (i in 1:seg.pair.num) {

    a <- pmi_list[[i]]$V1
    b <- pmi_list[[i]]$V2

    c1 <- X == a
    c2 <- X == b

    hit <- sum(X == a, X == b)
    if (hit == 0) {

    } else {
      pmi_mat[pmi_list[[i]]$V1, pmi_list[[i]]$V2, ] <- pmi_list[[i]]$pmi
      pmi_mat[pmi_list[[i]]$V2, pmi_list[[i]]$V1, ] <- pmi_list[[i]]$pmi
    }
  }

  if (sound == "CV") {
  # Prevent pairs of CV.
    pmi_mat[C, V, ] <- NA
    pmi_mat[V, C, ] <- NA
  }

  # If the symbol pair PMI has been used,
  # the matrix of the PMIs is changed
  # from a three-dimensional array to a matrix.
  if (length(pmi_list[[1]]$pmi) == 1) {
    pmi_mat <- as.matrix(pmi_mat[, , 1])
  }

  return(pmi_mat)
}
