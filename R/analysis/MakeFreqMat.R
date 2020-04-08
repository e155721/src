source("lib/load_scoring_matrix.R")
source("lib/load_phoneme.R")
source("lib/load_data_processing.R")

# Sub functions
MakeRegList <- function() {
  
  regions <- read.table("regions.tmp")
  regions <- as.vector(regions$V1)
  regions.list <- list()
  
  mask <- c(16, 14, 43, 8, 12, 2)
  head <- 1
  tail <- mask[1]
  for (i in 1:6) {
    regions.list[[i]] <- regions[head:tail]
    head <- tail + 1
    tail <- tail + mask[(i + 1)]
  }
  
  return(regions.list) 
}

CheckGroup <- function(region, regions.list) {
  
  groups.num <- length(regions.list)
  
  for (g in 1:groups.num) {
    match <- sum(region == regions.list[[g]])
    if (match) {
      return(g)
    } else {
      # NOP
    }
  }
  stop("ERROR\n")
}

MakeFreqMat <- function(dir) {
  
  # Make the regions list for each group.
  regions.list <- MakeRegList()
  
  # Make the words list.
  msa.list <- GetPathList(dir)
  msa.num  <- length(msa.list) 
  
  # The matrix initialization.
  names <- c(C, V, "-")
  
  # Make the combination of the groups.
  match <- rbind(1:6, 1:6)
  mismatch <- combn(1:6, 2, simplify = T)
  groups.comb <- cbind(match, mismatch)
  groups.comb <- paste(groups.comb[1, ], groups.comb[2, ], sep = "")
  
  # Make the matrix.
  s <- array(0, dim = c(119, 119, 22), dimnames = list(names, names, c(NA, groups.comb)))
  s[, , 1] <- MakeEditDistance(Inf)
  s[C, C, ] <- 0
  s[V, V, ] <- 0
  
  for (i in 1:msa.num) {
    # START LOOP
    msa <- read.table(msa.list[[i]]["input"])
    msa <- as.matrix(msa)
    
    seq.num <- dim(msa)[1]
    seq.comb <- combn(1:seq.num, 2, simplify = F)
    psa.num <- length(seq.comb)
    
    for (i in 1:psa.num) {
      seq.pair <- seq.comb[[i]]
      psa <- rbind(msa[seq.pair[1], ], msa[seq.pair[2], ])
      psa <- DelGap(psa)
      psa.col <- dim(psa)[2]
      
      # Check the group of the regions.
      reg1.g <- CheckGroup(psa[, 1][1], regions.list)
      reg2.g <- CheckGroup(psa[, 1][2], regions.list)
      
      g <- NULL
      g[1] <- min(reg1.g, reg2.g)
      g[2] <- max(reg1.g, reg2.g)
      g <- paste(g[1], g[2], sep = "")
      
      for (j in 2:psa.col) {
        x <- psa[, j][1]
        y <- psa[, j][2]
        s[x, y, 1] <- s[x, y, 1] + 1
        s[x, y, g] <- s[x, y, g] + 1
      }
    }
    # END LOOP
  }
  
  return(s)
}
