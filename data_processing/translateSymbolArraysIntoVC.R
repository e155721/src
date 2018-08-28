# load makeWordList
source("/Users/e155721/OkazakiLab/src/data_processing/makeWordList.R")

translateSymbolArraysIntoVC <- function(data_file, output_path)
{
  word_list <-  makeWordList(data_file)
  vowel <- read.table("/Users/e155721/OkazakiLab/src/symbols/vowel.txt")
  vowel <- vowel$V1
  
  # get the number of word_list
  list_length <- length(word_list)
  array_length <- length(word_list[[1]])
  
  # make a list that it has length of array_length
  l <- list()
  for (i in list_length)
    l[[i]] <- array(array_length)
  
  for (i in 1:list_length) {
    j = 1
    while (j<array_length+1) {
      sym <- word_list[[i]][j]
      if (sym != "-1") {
        sym <- is.element(word_list[[i]][j], vowel)
      } else {
        sym <- "-1"
      }
      
      if (sym == TRUE) {
        l[[i]][j] <- "V"
      } else if (sym == "-1") {
        l[[i]][j] <- "#"
      } else {
        l[[i]][j] <- "C"
      }
      j <- j+1
    }
  }
  
  #rlt <- matrix(NA, nrow = list_length, ncol = array_length)
  rlt <- matrix(NA, nrow = list_length)
  for (i in 1:list_length)
    rlt[i,] <- paste(l[[i]], collapse = "")
  
  path_length <- length(strsplit(data_file, "/")[[1]])
  output_file <- paste(output_path, strsplit(data_file, "/")[[1]][path_length], sep = "/")    
  write.table(rlt, output_file)
}