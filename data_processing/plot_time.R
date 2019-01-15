source("verification_multiple/align_for_each.R")
words.vec <- seq(10,100,10)

dir <- "../Alignment/ex-msa/ex-01_13/ex-time/rf_time/"
dir <- "../Alignment/ex-msa/ex-01_13/ex-time/bf_time/"
dir <- "../Alignment/ex-msa/ex-01_13/ex-time/rd_time/"

files <- GetFilesPath(dir)
time.vec <- c()
i <- 0
for (f in files) {
  i <- i + 1
  time <- read.table(f[["input"]])
  time.vec[i] <- sum(time$V2)
}

mat <- cbind(words.vec, rf.time)
mat <- cbind(mat, bf.time)
mat <- cbind(mat, rd.time)

write.table(mat, "time.txt")

write.table(cbind(words.vec, rf.time), "rf.time")
write.table(cbind(words.vec, bf.time), "bf.time")
write.table(cbind(words.vec, rd.time), "rd.time")


plot(time.vec, type = "l")

