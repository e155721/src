source("parallel_config.R")

source("dist/tools/get_regions.R")
source("dist/tools/make_mat.R")
source("dist/tools/dist.R")

load("all_list.RData")

dist_for_all <- function(method="lv") {
  
  r.pairs <- t(combn(2, 2))
  N <- dim(r.pairs)[1]
  
  tmp.list <- foreach (i = 1:N) %dopar% {
    
    k <- r.pairs[i, 1]
    l <- r.pairs[i, 2]
    
    # region
    r1 <- all.list[[k]]
    r2 <- all.list[[l]]
    
    mat.o  <- MakeMat(r1, r2, method)
    nr.vec <- each_nr(mat.o$mat, dist = is.dist(method))
    d      <- dist(nr.vec)
    
    tmp        <- list()
    tmp$pair   <- paste(regions[k], regions[l])  # for using UTF-8.
    tmp$pair   <- unlist(strsplit(tmp$pair, " "))
    
    tmp$psa_list <- mat.o$psa_list
    tmp$mat      <- mat.o$mat
    tmp$ranks    <- nr.vec
    tmp$dist     <- d
    tmp
  }
  
  psa_list <- foreach (i = 1:N) %dopar% {
    psa      <- list()
    psa$pair <- tmp.list[[i]]$pair
    
    psa$psa_list <- tmp.list[[i]]$psa_list
    psa
  }
  
  dist.list <- foreach (i = 1:N) %dopar% {
    dist      <- list()
    dist$pair <- tmp.list[[i]]$pair
    
    dist$mat   <- tmp.list[[i]]$mat
    dist$ranks <- tmp.list[[i]]$ranks
    dist$dist  <- tmp.list[[i]]$dist
    dist
  }
  
  psa_list$method  <- method
  dist.list$method <- method
  
  dist.o           <- list()
  dist.o$psa_list  <- psa_list
  dist.o$dist.list <- dist.list
  dist.o
}

method <- "lv"

dist.o <- dist_for_all(method)

print("Finished!!")
