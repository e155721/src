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
    tmp_vector <- as.vector(sheet[i,])
    tmp_vector <- tmp_vector[!is.na(tmp_vector)]
    if (length(tmp_vector) != 0)
      word_list[[i]] <- tmp_vector
  }
  
  return(word_list)
}