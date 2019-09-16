library("xtable")
library("R.utils")

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

source("data_processing/MakeWordList.R")
source("data_processing/list2mat.R")

# applicate the MakeTable() to each file
ExeMakeTable <- function(dir, ext1, ext2)
{
  dir <- paste(dir, "/", sep = "")
  files.list1 <- list.files(dir, ext1)
  files.list2 <- list.files(dir, ext2)
  
  len <- length(files.list1)
  foreach (i = 1:len) %dopar% {
    
    file1 <- paste(dir, files.list1[[i]], sep = "")
    file2 <- paste(dir, files.list2[[i]], sep = "")
    
    lines1 <- countLines(file1)
    lines2 <- countLines(file2)
    
    # file1
    n <- 1
    aln1 <- c()
    f1<-file(file1, "r")
    for(i in 1:lines1[[1]]){
      line <- readLines(con=f1, 1)
      if (line == "") {
        aln1 <- append(aln1, "¥", after = length(aln1))
      } else {
        aln1 <- append(aln1, paste("¥", n, line), after = length(aln1))
        n <- n + 1
      }
    }
    
    # file2
    aln2 <- c()
    f2 <- file(file2, "r")
    for(i in 1:lines2[[1]]){
      line <- readLines(con=f2, 1)
      if (line == "") {
        aln2 <- append(aln2, " ", after = length(aln2))
      } else {
        aln2 <- append(aln2, line, after = length(aln2))
      }
    }
    
    # file1
    aln1.list <- list()
    aln1.len <- length(aln1)
    for (j in 1:(aln1.len)) {
      aln1.list[[j]] <- matrix(unlist(strsplit(aln1[j], split = " ")), nrow = 1)
    }
    aln1.mat <- list2mat(aln1.list)
    
    # file2
    aln2.list <- list()
    aln2.len <- length(aln2)
    for (j in 1:(aln2.len)) {
      aln2.list[[j]] <- matrix(unlist(strsplit(aln2[j], split = " ")), nrow = 1)
    }
    aln2.mat <- list2mat(aln2.list)
    
    # making alignment matrix
    align.mat <- cbind(aln1.mat, aln2.mat)
    
    # get the number of column
    align.col <- dim(align.mat)[2]
    # get the number of column of alignment1
    aln1.col <- dim(aln1.mat)[2]
    aln1.col <- aln1.col-1
    # get the number of column of alignment2
    aln2.col <- dim(aln2.mat)[2]
    aln2.col <- aln2.col
    
    # making the xtable
    align <- c()
    align.col <- align.col + 1
    align <- c("r", "l")
    for (col in 3:align.col) {
      if (col != aln1.col) {
        align <- append(align, "c")
      } else {
        align <- append(align, "c|")
      }
    }
    
    # output tex file
    sink(gsub("\\..*$", 
              paste("_", (align.col-2), "-", (aln1.col-2), "-", aln2.col, "\\.tex", sep = ""),
              file1))
    print(xtable(align.mat, align = align))
    sink()
  }
  
  return(0)
}

# reference from command line
dir <- commandArgs(trailingOnly=TRUE)[1]
ext1 <- commandArgs(trailingOnly=TRUE)[2]
ext2 <- commandArgs(trailingOnly=TRUE)[3]
ExeMakeTable(dir, ext1, ext2) 
