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
  
  sink(gsub("\\..*$", "\\.tex", file1))
  print(xtable(align.mat))
  sink()
  
}

dir <- "/Users/e155721/OkazakiLab/Experiment/Alignment/ex-msa/msa_mismatch-02_11/dat/"
files.rf <- list.files(dir, ".rf")
files.lg <- list.files(dir, ".lg")

len <- length(files.rf)
for (i in 1:len) {
  file1 <- files.rf[[i]]
  file2 <- files.lg[[i]]
  
  file1 <- paste(dir, file1, sep = "")
  file2 <- paste(dir, file2, sep = "")
  
  MakeTable(file1, file2)
}

if (1) {
  dir <- "/Users/e155721/OkazakiLab/Experiment/Alignment/ex-pairwise/nw_mismatch/remove_dup/"
  files.nw <- list.files(dir, ".nw")
  files.lg <- list.files(dir, ".lg")
  
  len <- length(files.nw)
  for (i in 1:len) {
    file1 <- files.nw[[i]]
    file2 <- files.lg[[i]]
    
    file1 <- paste(dir, file1, sep = "")
    file2 <- paste(dir, file2, sep = "")
    
    MakeTable(file1, file2)
  }
}
