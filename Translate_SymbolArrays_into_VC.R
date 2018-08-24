Translate_SymbolArrays_into_VC <- function(data_file)
{
  # make word list
  makeWordList <- function(file)
  {
    # load words data
    sheet <- read.table(file, sep = " ")
    sheet <- as.matrix(sheet)
    
    nrow <- dim(sheet)[1]
    word_list <- list()
    for (i in 1:nrow) {
      tmpList <- as.vector(sheet[i,])
      word_list[[i]] <- tmpList[!is.na(tmpList)]
    }
    
    return(word_list)
  }
  
  word_list <-  makeWordList(data_file)
  vowel <- read.table("vowel.txt")
  vowel <- vowel$V1
  
  list_length <- length(word_list)
  array_length <- length(word_list[[1]])
  l <- list()
  for (i in list_length) {
    l[[i]] <- array(array_length)
  }
  
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
      }
      else if (sym == "-1") {
        l[[i]][j] <- "-1"
      }
      else {
        l[[i]][j] <- "C"
      }
      j <- j+1
    }
  }
  
  rlt <- matrix(NA, nrow = list_length, ncol = array_length)
  for (i in 1:list_length) {
    rlt[i,] <- l[[i]]
  }
  
  path_length <- length(strsplit(data_file, "/")[[1]])
  output_file <- paste("output/", strsplit(data_file, "/")[[1]][path_length], sep = "")    
  write.table(rlt, output_file)
}

for (f in dir) {
  Translate_SymbolArrays_into_VC(f)
}