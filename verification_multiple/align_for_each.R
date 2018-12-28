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
  
  msa.vec <- c(f[["name"]], matchingRate)
  return(msa.vec)
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
  msa.list <- foreach (f = filesPath) %dopar% {
    MPA(f, method, output, p, s)
  }
  
  seq.num <- length(msa.list)
  msa.mat <- matrix(NA, seq.num, 2)
  for (i in 1:seq.num) {
    msa.mat[i, ] <- msa.list[[i]]
  }
  msa.mat <- msa.mat[order(msa.mat[, 1]), ]
  
  sink(output)
  for (i in 1:seq.num) {
    print(msa.mat[i, ])
  }
  sink()
  
  #write.table(msa.mat, output)
}
