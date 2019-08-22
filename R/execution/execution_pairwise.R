source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("verification/verif_lib/verification_func.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
path.list <- GetPathList()

p <- -3
digits <- 2

ansrate.dir <- paste("../../Alignment/ansrate_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(ansrate.dir)) {
  dir.create(ansrate.dir)
}

output.dir <- paste("../../Alignment/pairwise_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# matchingrate path
ansrate.file <- paste(ansrate.dir, "ansrate_p_",
                      formatC(-p, width = digits, flag = 0), ".txt", sep = "")

# result path
output.dir.sub <- paste(output.dir, "pairwise_p_",
                        formatC(-p, width = digits, flag = 0), "/", sep = "")
if (!dir.exists(output.dir.sub)) {
  dir.create(output.dir.sub)
}

f <- path.list[[2]]
# make the word list
word.list <- MakeWordList(f["input"])
word.list <- MakeInputSeq(word.list)

# make scoring matrix
s <- MakeFeatureMatrix(-Inf, p)

# making the pairwise alignment in all regions
psa.aln <- MakePairwise(word.list, s)

# output pairwise
OutputAlignment(f["name"], output.dir.sub, ".aln", psa.aln)
