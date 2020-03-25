source("lib/load_data_processing.R")
source("lib/load_scoring_matrix.R")
source("lib/load_exec_align.R")
source("lib/load_verif_lib.R")
source("verification_multiple/CalcAccMSA.R")
source("parallel_config.R")
source("lib/load_phoneme.R")

ansrate <- "ansrate_msa_pf-pmi"
multiple <- "multiple_pf-pmi"
ext = commandArgs(trailingOnly=TRUE)[1]
path <- MakePath(ansrate, multiple, ext)

# Get the all of files path.
list.words <- GetPathList()
s <- MakeEditDistance(Inf)
#load("../../Alignment/ex_03-23/matrix_PF-PMI_L1.RData")  # L1
load("../../Alignment/ex_03-23/matrix_PF-PMI_L2.RData")  # L2

N <- dim(pmi.mat)[1]
norm <- NULL
s.tmp <- matrix(NA, nrow = N, ncol = N, 
                dimnames = list(dimnames(s)[[1]], dimnames(s)[[2]]))

for (i in 1:N) {
  for (j in 1:N) {
    v <- pmi.mat[i, j, ]
    #s.tmp[i, j] <- -sum(abs(v))  # L1
    s.tmp[i, j] <- -sqrt(sum(v * v))  # L2
  }
}

max <- max(s.tmp[!is.na(s.tmp)])
min <- min(s.tmp[!is.na(s.tmp)])
for (i in 1:N) {
  for (j in 1:N) {
    if (is.na(s.tmp[i, j])) {
      # NOP
    } else {
      s[i, j] <- (s.tmp[i, j] - min) / (max - min)
    }
  }
}

msa.list <- MSAforEachWord(list.words, s)
CalcAccMSA(msa.list, list.words, path$ansrate.file, path$output.dir)
