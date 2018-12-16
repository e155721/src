.myfunc.env = new.env()
sys.source("needleman_wunsch/MakeFeatureMatrix.R", envir = .myfunc.env)
sys.source("verification/GetFilesPath.R", envir = .myfunc.env)
sys.source("verification_multiple/ProgressiveAlignment.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationPA.R", envir = .myfunc.env)
sys.source("verification_multiple/VerificationIR.R", envir = .myfunc.env)
attach(.myfunc.env)

# make scoring matrix and gap penalty
scoringMatrix <- MakeFeatureMatrix(-10, -3)
p <- -3

# get the all of files path
filesPath <- GetFilesPath(inputDir = "../Alignment/input_data/",
                          correctDir = "../Alignment/correct_data/")

# alignment for each
for (f in filesPath) {
  # matchingRate <- VerificationPA(f[["input"]], f[["correct"]], p, scoringMatrix)
  matchingRate <- VerificationIR(f[["input"]], f[["correct"]], p, scoringMatrix)
  print(paste(basename(f[["input"]]), matchingRate, sep = ": "))
  
  # sink("multi_test.txt", append = T)
  sink("IR_result.txt", append = T)
  print(paste(f[["name"]], matchingRate, sep = " "), quote = F)
  sink()
}
