source("verification_multiple/align_for_each.R")
words.vec <- seq(10,100,10)

dir <- "../Alignment/bf_time/"
files <- GetFilesPath(dir)
time.vec <- c()
i <- 0
for (f in files) {
  i <- i + 1
  time <- read.table(f[["input"]])
  time.vec[i] <- sum(time$V2)
}
