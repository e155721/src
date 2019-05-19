source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("verification/ForEachRegion.R")
source("verification/MakeGoldStandard.R")
source("verification/MakePairwise.R")
source("verification/VerifAcc.R")
source("verification/OutputAlignment.R")
source("needleman_wunsch/MakeFeatureMatrix.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
filesPath <- GetPathList()

pVec <- 1
digits <- 2
lenpVec <- length(pVec)

pairwise <- foreach (p = pVec) %dopar% {
  
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
  for (f in filesPath) {
    
    print(paste("input:", f["input"], sep = " "))
    print(paste("correct:", f["correct"], sep = " "))
    cat("\n")
    
    # make the word list
    word.list <- MakeWordList(f["input"])
    correct.aln <- MakeWordList(f["correct"])
    
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
    OutputAlignment(f["name"], output.dir.sub, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir.sub, ".aln", psa.aln)
    
    # output the matching rate
    sink(ansrate.file, append = T)
    rlt <- paste(f["name"], matching.rate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}
