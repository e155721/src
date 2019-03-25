library("xtable")
library("R.utils")

source("data_processing/MakeWordList.R")
source("data_processing/list2mat.R")

MakeTable <- function(file1, file2)
{
  lines1 <- countLines(file1)
  lines2 <- countLines(file2)
  
  nw <- c()
  nw.list <- list()
  
  lg <- c()
  lg.list <- list()
  
  # file1
  num <- 1
  f1<-file(file1, "r")
  for(i in 1:lines1[[1]]){
    line <- readLines(con=f1, 1)
    
    if (line == "")
      nw <- append(nw, "¥", after = length(nw))
    else {
      nw <- append(nw, paste("¥", num, line), after = length(nw))
      num <- num + 1
    }
  }
  
  # file2
  f2 <- file(file2, "r")
  for(i in 1:lines2[[1]]){
    line <- readLines(con=f2, 1)
    
    if (line == "") {
      lg <- append(lg, " ", after = length(lg))
    } else {
      lg <- append(lg, line, after = length(lg))
    }
  }
  
  # file1
  nw.len <- length(nw)
  for (j in 1:(nw.len))
    nw.list[[j]] <- matrix(unlist(strsplit(nw[j], split = " ")), nrow = 1)
  nw.mat <- list2mat(nw.list)
  
  # file2
  lg.len <- length(lg)
  for (j in 1:(lg.len))
    lg.list[[j]] <- matrix(unlist(strsplit(lg[j], split = " ")), nrow = 1)
  lg.mat <- list2mat(lg.list)
  
  align.mat <- cbind(nw.mat, lg.mat)
  
  # get the num of col
  align.col <- dim(align.mat)[2]

  nw.col <- dim(nw.mat)[2]
  nw.col <- nw.col-1

  lg.col <- dim(lg.mat)[2]
  lg.col <- lg.col
  
  # make the xtable align
  align <- c()
  align.col <- align.col + 1
  align <- c("r", "l")
  for (col in 3:align.col) {
    if (col != nw.col) {
      align <- append(align, "c")
    } else {
      align <- append(align, "c|")
    }
  }
  
  # output tex file
  sink(gsub("\\..*$", 
            paste("-", (align.col-2), "-", (nw.col-2), "-", lg.col, "\\.tex", sep = ""),
            file1))
  print(xtable(align.mat, align = align))
  sink()
  
  return(0)
}

# applicate the MakeTable() to each file
ExeMakeTable <- function(dir)
{
  dir <- paste(dir, "/", sep = "")
  files.aln <- list.files(dir, ".aln")
  files.lg <- list.files(dir, ".lg")
  
  len <- length(files.aln)
  for (i in 1:len) {
    file1 <- files.aln[[i]]
    file2 <- files.lg[[i]]
    
    file1 <- paste(dir, file1, sep = "")
    file2 <- paste(dir, file2, sep = "")
    
    MakeTable(file1, file2)
  }
  
  return(0)
}

# reference from command line
dir = commandArgs(trailingOnly=TRUE)[1]
ExeMakeTable(dir)
