source("needleman_wunsch/MakeFeatureMatrix.R")
source("data_processing/GetPathList.R")
source("verification_multiple/for_acc/VerificationIR.R")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

verif <- function(method, output = "multi_test.txt", p = -3, words = NA)
{
  # get the all of files path
  filesPath <- GetPathList()
  
  # decide the number of words
  if (!is.na(words)) {
    filesPath <- filesPath[1:words]
  }
  
  # alignment for each
  msa.list <- foreach (f = filesPath) %dopar% {
    matchingRate <- VerificationIR(method, f[["input"]], f[["correct"]], p, words)
    sink(output, append = T)
    print(paste(gsub("\\..*$", "", f[["name"]]), matchingRate), quote = F)
    sink()
  }
  
  return(0)
}
