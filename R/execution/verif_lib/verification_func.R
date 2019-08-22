LoadVerifFunc <- function()
{
  lib.path <- paste(getwd(), "verification/verif_lib/", sep = "/")
  
  #  "/Users/e155721/OkazakiLab/Experiment/src/R/verification/verif_lib/"
  source((paste(lib.path, "MakeGoldStandard.R", sep = "")))
  source((paste(lib.path, "MakePairwise.R", sep = "")))
  source((paste(lib.path, "MakeCorpus.R", sep = "")))
  source((paste(lib.path, "VerifAcc.R", sep = "")))
  source((paste(lib.path, "OutputAlignment.R", sep = "")))
  source((paste(lib.path, "PMI.R", sep = "")))
  source((paste(lib.path, "MakeInputSeq.R", sep = "")))
  source((paste(lib.path, "OutputAlignmentCheck.R", sep = "")))
  
  return(0)
}

LoadVerifFunc()
