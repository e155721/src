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