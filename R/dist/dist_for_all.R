source("parallel_config.R")

source("dist/tools/get_regions.R")
source("dist/tools/make_mat.R")
source("dist/tools/dist.R")

load("all_list.RData")

dist_for_all <- function(file, method="lv") {
  
  r <- t(combn(95, 2))
  N <- dim(r)[1]
  
  dist.list <- foreach (i = 1:N) %dopar% {
    
    k <- r[i, 1]
    l <- r[i, 2]
    
    # region
    r1 <- all.list[[k]]
    r2 <- all.list[[l]]
    
    mat    <- MakeMat(r1, r2, method)
    nr.vec <- each_nr(mat, dist = is.dist(method))
    d      <- Dist(nr.vec)
    
    dist       <- list()
    dist$pair  <- paste(regions[k], regions[l])
    dist$mat   <- mat
    dist$ranks <- nr.vec
    dist$dist  <- d
    return(dist)
  }
  
  save(dist.list, file = paste(file, ".RData", sep = ""))
}

file   = commandArgs(trailingOnly=TRUE)[1]
method = commandArgs(trailingOnly=TRUE)[2]

if (is.na(method)) {
  method <- "lv"
} else {
 # NOP 
}

if (is.na(file)) {
  stop("An output file name must be selected.")
} else {
  print(paste("File:", file))
  print(paste("Method:", method))
  dist_for_all(file, method)
}
