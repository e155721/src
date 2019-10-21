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

null <- foreach (p = p.vec) %do% {
  
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
  foreach.rlt <- foreach (f = path.list) %dopar% {
    
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
    matching.rate <- VerifAcc(psa.aln, gold.aln)
    
    # output gold standard
    OutputAlignment(f["name"], output.dir.sub, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir.sub, ".aln", psa.aln)
    # output match or mismatch
    OutputAlignmentCheck(f["name"], output.dir.sub, ".check", psa.aln, gold.aln)
    
    # Returns the matching rate to the list of foreach.
    c(f["name"], matching.rate)
  }
  
  # Outputs the matching rate
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop=F]
  write.table(matching.rate.mat, ansrate.file, quote = F)
}
