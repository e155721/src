source("dist/tools/get_regions.R")

MakeDistMat <- function(dist.list) {
  # dist.list: a list of distances.
  
  mat <- matrix(NA, 95, 95, dimnames = list(regions, regions))
  
  N <- length(dist.list)
  for (i in 1:N) {
    pair <- dist.list[[i]]$pair
    pair <- unlist(strsplit(pair, " "))
    mat[pair[1], pair[2]] <- dist.list[[i]]$dist
  }
  
  dimnames(mat)       <- list(regions.d, regions.d)
  mat.tmp             <- t(mat)
  mat[lower.tri(mat)] <- mat.tmp[lower.tri(mat.tmp)]
  
  mat.d  <- as.dist(mat)
  return(mat.d)
}
