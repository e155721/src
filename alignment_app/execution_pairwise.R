source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("data_processing/list2mat.R")
source("needleman_wunsch/MakeFeatureMatrix.R")
source("verification/verif_lib/verification_func.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

PF <- function(word)
{
  # get the all of files path
  path.list <- GetPathList("data")
  file.vec <- list2mat(path.list)[, 2]
  f <- path.list[[match(word, file.vec)]]
  
  p <- -3
  # digits <- 2
  
  if (0) {
    output.dir <- paste("../../Alignment/pairwise_", format(Sys.Date()), "/", sep = "")
    if (!dir.exists(output.dir)) {
      dir.create(output.dir)
    }
    
    # result path
    output.dir.sub <- paste(output.dir, "pairwise_p_",
                            formatC(-p, width = digits, flag = 0), "/", sep = "")
    if (!dir.exists(output.dir.sub)) {
      dir.create(output.dir.sub)
    }
  }
  
  word.list <- MakeWordList(f["input"])
  word.list <- MakeInputSeq(word.list)
  
  # make scoring matrix
  s <- MakeFeatureMatrix(-Inf, p)
  
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s)
  
  psa.aln <- list2mat(psa.aln)
  return(psa.aln)
}
