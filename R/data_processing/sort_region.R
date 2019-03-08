source("data_processing/MakeWordList.R")
source("verification/GetPathList.R")
source("data_processing/list2mat.R")

files <- GetPathList()
for (f in files) {
  wl.list <- MakeWordList(f[["correct"]])
  wl.mat <-list2mat(wl.list)
  wl.mat <- wl.mat[order(wl.mat[, 1]), ]
  write.table(wl.mat, paste(gsub("\\..*", "", f[["name"]]), ".sort", sep = ""))
}
