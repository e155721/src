# make word list
makeWordList <- function(file)
{
  # load words data
  sheet <- read.table(file, sep = " ")
  sheet <- as.matrix(sheet)
  
  # get rows number of data sheet
  nrow <- dim(sheet)[1]
  
  word_list <- list()
  for (i in 1:nrow) {
    tmp_list <- as.vector(sheet[i,])
    word_list[[i]] <- tmp_list[!is.na(tmp_list)]
  }
  
  return(word_list)
}