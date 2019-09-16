source("data_processing/MakeWordList.R")
source("data_processing/GetPathList.R")
source("needleman_wunsch/MakeEditDistance.R")
source("verification/verif_lib/verification_func.R")
source("verification/verif_lib/MakeInputSeq.R")
source("data_processing/list2mat.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

LV <- function(word)
{
  # get the all of files path
  path.list <- GetPathList("data")
  file.vec <- list2mat(path.list)[, 2]
  f <- path.list[[match(word, file.vec)]]
  
  if (0) {
    # matchingrate path
    ansrate.file <- "../../Alignment/ansrate_levenshtein.txt"
    
    # result path
    output.dir <- paste("../../Alignment/pairwise_levenshtein_", format(Sys.Date()), "/", sep = "")
    if (!dir.exists(output.dir)) {
      dir.create(output.dir)
    }
  }
  
  # make scoring matrix
  s <- MakeEditDistance(Inf)
  
  # make the word list
  word.list <- MakeWordList(f["input"])
  word.list <- MakeInputSeq(word.list)
  
  # making the pairwise alignment in all regions
  psa.aln <- MakePairwise(word.list, s, fmin = T)
  
  psa.aln <- list2mat(psa.aln)
  return(psa.aln)
}
