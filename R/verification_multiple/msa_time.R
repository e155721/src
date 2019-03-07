source("verification_multiple/for_time/IRTime.R")
source("data_processing/GetPathList.R")

wordNum <- seq(10,110,10)

for (method in c("rf", "bf", "rd")) {
  for (words in wordNum) {
    # decide the number of words
    filesPath <- GetPathList()
    filesPath <- filesPath[1:words]
    
    # alignment for each
    for (f in filesPath) {
      IRTime(method, f[["input"]], words)
    }
  }
}