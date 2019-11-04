source("lib/load_data_processing.R")
source("lib/load_verif_lib.R")
source("lib/load_scoring_matrix.R")

source("psa/levenshtein.R")
source("psa/pmi.R")
source("psa/pf.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

VerificationPSA <- function(ansrate, pairwise, method, pen=NULL) {
  
  # matchingrate path
  ansrate.file <- paste("../../Alignment/", ansrate, "_", format(Sys.Date()), pen, ".txt", sep = "")
  
  # result path
  output.dir <- paste("../../Alignment/", pairwise, "_", format(Sys.Date()), pen, "/", sep = "")
  if (!dir.exists(output.dir)) {
    dir.create(output.dir)
  }
  
  # conduct the alignment for each files
  foreach.rlt <- foreach (f = filesPath) %dopar% {
    
    # make the word list
    gold.list <- MakeWordList(f["input"])
    input.list <- MakeInputSeq(gold.list)
    
    # making the gold standard alignments
    gold.aln <- MakeGoldStandard(gold.list)
    
    # Makes the scoring matrix.
    if (method == "PF" || method == "PF-PMI") {
      s <- MakeFeatureMatrix(-Inf, pen)
    } else {
      s <- MakeEditDistance(Inf)
    }    
    
    psa.aln <- switch(method,
                      "LV" = PairwiseLV(input.list, s),
                      "PMI" = PairwisePMI(input.list, s),
                      "PF" = PairwisePF(input.list, s),
                      "PF-PMI" = PairwisePFPMI(input.list, s)
    )
    
    #######
    # calculating the matching rate
    matching.rate <- VerifAcc(psa.aln, gold.aln)
    # output gold standard
    OutputAlignment(f["name"], output.dir, ".lg", gold.aln)
    # output pairwise
    OutputAlignment(f["name"], output.dir, ".aln", psa.aln)
    # output match or mismatch
    OutputAlignmentCheck(f["name"], output.dir, ".check", psa.aln, gold.aln)
    
    # Returns the matching rate to the list of foreach.
    c(f["name"], matching.rate)
  }
  
  # Outputs the matching rate
  matching.rate.mat <- list2mat(foreach.rlt)
  matching.rate.mat <- matching.rate.mat[order(matching.rate.mat[, 1]), , drop=F]
  write.table(matching.rate.mat, ansrate.file, quote = F)
  
  return(0)
}
