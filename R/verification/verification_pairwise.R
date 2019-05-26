source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("verification/verif_lib/verification_func.R")
source("verification/verif_lib/MakeInputSeq.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

pVec <- 3
digits <- 2
lenpVec <- length(pVec)

pairwise <- foreach (p = pVec) %do% {
  
  ansrate.dir <- paste("../../Alignment/ansrate_", format(Sys.Date()), "/", sep = "")
  print(ansrate.dir)
  if (!dir.exists(ansrate.dir)) {
    dir.create(ansrate.dir)
  }
  
  output.dir <- paste("../../Alignment/pairwise_", format(Sys.Date()), "/", sep = "")
  print(output.dir)
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # matchingrate path
  ansrate.file <- paste(ansrate.dir, "ansrate_p_",
                        formatC(p, width = digits, flag = 0), ".txt", sep = "")
  
  # result path
  output.dir.sub <- paste(output.dir, "pairwise_p_",
                          formatC(p, width = digits, flag = 0), "/", sep = "")
  if (!dir.exists(output.dir.sub)) {
    dir.create(output.dir.sub)
  }
  
  # conduct the alignment for each files
  foreach (f = filesPath) %dopar% {
    
    print(paste("input:", f["input"], sep = " "))
    cat("\n")
    
    # make the word list
    correct.aln <- MakeWordList(f["input"])
    word.list <- MakeInputSeq(correct.aln)
    
    # get the number of the regions
    regions <- length(word.list)
    
    # make scoring matrix
    s <- MakeFeatureMatrix(-10, -p)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(correct.aln, regions)
    
    # making the pairwise alignment in all regions
    psa.aln <- MakePairwise(word.list, regions, s)
    
    # calculating the matching rate
    matching.rate <- VerifAcc(gold.aln, psa.aln, regions)
    
    # output gold standard
    OutputAlignment(f["input"], output.dir.sub, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["input"], output.dir.sub, ".aln", psa.aln)
    
    # output the matching rate
    sink(ansrate.file, append = T)
    rlt <- paste(f["input"], matching.rate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}
