.myfunc.env = new.env()
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("verification/GetFilesPath.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationPA.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationRF.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationBF.R", envir = .myfunc.env)
attach(.myfunc.env)

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

MPA <- function(f, method, output, p, s)
{
  print(paste("Executing:",f[["name"]]))
  switch (method,
          "pa" = matchingRate <- VerificationPA(f[["input"]], f[["correct"]], p, s),
          "rf" = matchingRate <- VerificationRF(f[["input"]], f[["correct"]], p, s),
          "bf" = matchingRate <- VerificationBF(f[["input"]], f[["correct"]], p, s)
  )
  print(paste("Finished:",f[["name"]]))

  sink(output, append = T)
  print(paste(f[["name"]], matchingRate, sep = " "), quote = F)
  sink()
}

verif <- function(method, output = "multi_test.txt")
{
  # make scoring matrix and gap penalty
  s <- MakeFeatureMatrix(-10, -3)
  p <- -3
  
  # get the all of files path
  filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                            correctDir = "../Alignment/correct_data/")
  
  # alignment for each
  foreach (f = filesPath) %dopar% {
    MPA(f, method, output, p, s)
  }
}
