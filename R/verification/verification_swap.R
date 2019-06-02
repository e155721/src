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
ansrate.file <- "../../Alignment/ansrate_swap.txt"

# result path
output.dir <- paste("../../Alignment/pairwise_swap", format(Sys.Date()), "/", sep = "")
if (!dir.exists(output.dir)) {
  dir.create(output.dir)
}

# make scoring matrix
s <- MakeEditDistance(Inf)

# conduct the alignment for each files
foreach.rlt <- foreach (f = filesPath) %dopar% {
  
  # make the word list
  gold.list <- MakeWordList(f["input"])
  word.list <- MakeInputSeq(gold.list)
  
  # making the gold standard alignments
  gold.aln <- MakeGoldStandard(gold.list)
  
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s, fmin = T)
  
  # calculating the matching rate
  matching.rate <- VerifAcc(gold.aln, psa.aln)
  
  # output gold standard
  OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
  # output pairwise
  OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
  # output match or mismatch
  OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)
  # output match or mismatch
  OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)
    
  # output the matching rate
  sink(ansrate.file, append = T)
  rlt <- paste(f["name"], matching.rate, sep = " ")
  print(rlt, quote = F)
  sink()
}
