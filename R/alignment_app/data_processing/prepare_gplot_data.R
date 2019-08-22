source("verification/GetPathList.R")

# make data files to plot graphs by gnuplot
MakeData <- function(files, xrange, output)
{
  ave <- c()
  for (f in files) {
    dat <- read.table(f[["input"]])
    ave <- append(ave, sum(dat[, 3])/dim(dat)[1])
  }
  
  ave.mat <- cbind(xrange, ave)
  write.table(ave.mat, output)
  return(0)
}

files <- GetPathList("../Alignment/ex-pairwise/ex-12_03/gap/gap_01-10/gap_03/")
xrange <- seq(-1,-10,-1)
#MakeData(files, xrange, "gap_03.ave")
MakeData(files, xrange, "gap_05.ave")

files <- GetPathList("../Alignment/ex-pairwise/ex-12_03/gap/gap_03-15/gap_05/")
xrange <- seq(-1,-15,-1)
MakeData(files, xrange, "gap_05.ave")
