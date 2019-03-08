source("verification_multiple/for_time/align_for_each.R")

words.vec <- seq(10,110,10)

dir_rf <- "../../Alignment/ex-msa/old/ex-01_13/ex-time/rf_time/"
dir_bf <- "../../Alignment/ex-msa/old/ex-01_13/ex-time/bf_time/"
dir_rd <- "../../Alignment/ex-msa/old/ex-01_13/ex-time/rd_time/"

GetTime <- function(dir, words.vec)
{
  files <- GetPathList(dir)
  time.vec <- c()
  i <- 0
  for (f in files) {
    time <- read.table(f[["input"]])
    time.vec <- append(time.vec, sum(time$V2))
  }
  
  mat <- cbind(words.vec, time.vec)
  return(mat)
}

rf.time <- GetTime(dir_rf, words.vec)
bf.time <- GetTime(dir_bf, words.vec)
rd.time <- GetTime(dir_rd, words.vec)

write.table(rf.time, "rf.time")
write.table(bf.time, "bf.time")
write.table(rd.time, "rd.time")
