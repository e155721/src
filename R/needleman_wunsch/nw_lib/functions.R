libPath <- paste(getwd(), "needleman_wunsch/nw_lib/", sep = "/")

#  "/Users/e155721/OkazakiLab/Experiment/src/R/needleman_wunsch/nw_lib/"

# source(paste(libPath, "MakeMatrix.R", sep = ""))
# Msource((paste(libPath, "InitializeMat.R", sep = "")))
source((paste(libPath, "D.R", sep = "")))
source((paste(libPath, "SP.R", sep = "")))
source((paste(libPath, "MaxD.R", sep = "")))
source((paste(libPath, "TraceBack.R", sep = "")))