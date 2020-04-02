source("lib/load_scoring_matrix.R")
source("lib/load_phoneme.R")
source("lib/load_data_processing.R")

MakeHistMat <- function(dir) {
  
  words.list <- GetPathList(dir)
  num.words <- length(words.list) 
  
  # The matrix initialization.
  s <- MakeEditDistance(Inf)
  s[C, C] <- 0
  s[V, V] <- 0
  
  for (i in 1:num.words) {
    # START LOOP
    msa <- read.table(words.list[[i]]["input"])
    msa <- as.matrix(msa)
    
    msa.dim <- dim(msa)
    psa.all <- t(combn(1:msa.dim[1], 2))
    psa.all.row <- dim(psa.all)[1]
    
    for (i in 1:psa.all.row) {
      pair <- psa.all[i, ]
      psa <- rbind(msa[pair[1], -1], msa[pair[2], -1])
      psa <- DelGap(psa)
      psa.col <- dim(psa)[2]
      for (j in 1:psa.col) {
        s[psa[, j][1], psa[, j][2]] <- s[psa[, j][1], psa[, j][2]] + 1
      }
    }
    # END LOOP
  }
  
  return(s)
}

MakeHistMat("../../Alignment/msa_pmi/multiple_pmi_gap-op-old_2020-02-17/")
