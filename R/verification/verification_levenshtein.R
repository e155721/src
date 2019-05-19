source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("needleman_wunsch/MakeEditDistance.R")
source("verification/verif_lib/verification_func.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

# matchingrate path
ansrate.file <- "../../Alignment/ansrate_levenshtein.txt"

# result path
output.dir <- paste("../../Alignment/pairwise_", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# make scoring matrix
s <- MakeEditDistance(10)

# conduct the alignment for each files
foreach (f = filesPath) %dopar% {
  print(f["name"])
  print(paste("input:", f["input"], sep = " "))
  print(paste("correct:", f["correct"], sep = " "))
  cat("\n")
  
  # make the word list
  word.list <- MakeWordList(f["input"])
  correct.aln <- MakeWordList(f["correct"])
  
  # get the number of the regions
  regions <- length(word.list)
  
  # making the gold standard alignments
  gold.aln <- MakeGoldStandard(correct.aln, regions)
  
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, regions, s, fmin = T)
  
  # calculating the matching rate
  matching.rate <- VerifAcc(gold.aln, psa.aln, regions)
  
  # output gold standard
  OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
  # output pairwise
  OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
  
  # output the matching rate
  sink(ansrate.file, append = T)
  rlt <- paste(f["name"], matching.rate, sep = " ")
  print(rlt, quote = F)
  sink()
}
