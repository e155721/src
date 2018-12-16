# make word list
MakeWordList <- function(file)
{
  # load words data
  sheet <- read.table(file, sep = " ")
  sheet <- as.matrix(sheet)
  
  # get rows number of data sheet
  nrow <- dim(sheet)[1]
  
  # get region name symbols
  regVec <- as.vector(sheet[, 1])
  regVec <- regVec[!is.na(regVec)]
  sheet <- sheet[, -1]
  
  word_list <- list()
  k <- 1
  for (i in 1:nrow) {
    tmp_vector <- as.vector(sheet[i, ])
    tmp_vector <- tmp_vector[!is.na(tmp_vector)]
    if (length(tmp_vector) != 0) {
      word_list[[k]] <- t(as.matrix(tmp_vector))
      k <- k + 1
    }
  }
  
  len <- length(regVec)
  for (i in 1:len) {
    word_list[[i]] <- cbind(regVec[i], word_list[[i]])
  }
  
  return(word_list)
}
