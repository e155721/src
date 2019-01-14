.myfunc.env = new.env()
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("verification/GetFilesPath.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationPA.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationRF.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationBF.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationRD.R", envir = .myfunc.env)
attach(.myfunc.env)

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

MPA <- function(f, method, output, p, s)
{
  switch (method,
          "pa" = matchingRate <- VerificationPA(f[["input"]], f[["correct"]], p, s),
          "rf" = matchingRate <- VerificationRF(f[["input"]], f[["correct"]], p, s),
          "bf" = matchingRate <- VerificationBF(f[["input"]], f[["correct"]], p, s),
          "rd" = matchingRate <- VerificationRD(f[["input"]], f[["correct"]], p, s)
  )
  
  sink(output, append = T)
  print(paste(f[["name"]], matchingRate), quote = F)
  sink()
}

verif <- function(method, output = "multi_test.txt", p = -3, words = NA)
{
  # make scoring matrix and gap penalty
  s <- MakeFeatureMatrix(-10, p)
  
  # get the all of files path
  filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                            correctDir = "../Alignment/correct_data/")
  
  # decide the number of words
  if (!is.na(words)) {
    filesPath <- filesPath[1:words]
  }
  
  # alignment for each
  msa.list <- foreach (f = filesPath) %dopar% {
    MPA(f, method, output, p, s)
  }
  
}
