source("data_processing/MakeWordList.R")
source("data_processing/list2mat.R")
source("data_processing/DelGap.R")

dir <- "../../Alignment/correct_data/"
files <- list.files(dir)
filePaths <- paste(dir, files, sep = "/")

for (f in filePaths) {
  f.list <- MakeWordList(f)
  f.mat <- list2mat(f.list)
  f.mat <- DelGap(f.mat)
  write.table(f.mat, f)
}
