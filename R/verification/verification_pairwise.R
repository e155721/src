source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")
source("verification/methods/MakePairwise.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# get the all of files path
path.list <- GetPathList()

p.vec <- -3
digits <- 2

pairwise <- foreach (p = p.vec) %do% {
  
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
  
  # conduct the alignment for each files
  foreach (f = path.list) %dopar% {
    
    # make the word list
    gold.list <- MakeWordList(f["input"])
    word.list <- MakeInputSeq(gold.list)
    
    # make scoring matrix
    s <- MakeFeatureMatrix(-Inf, p)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(gold.list)
    
    # making the pairwise alignment in all regions
    psa.aln <- MakePairwise(word.list, s)
    
    # calculating the matching rate
    matching.rate <- VerifAcc(gold.aln, psa.aln)
    
    # output gold standard
    OutputAlignment(f["name"], output.dir.sub, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir.sub, ".aln", psa.aln)
    # output match or mismatch
    OutputAlignmentCheck(f["name"], output.dir.sub, ".check", psa.aln, gold.aln)
    
    # output the matching rate
    sink(ansrate.file, append = T)
    rlt <- paste(f["name"], matching.rate, sep = " ")
    print(rlt, quote = F)
    sink()
  }
}
