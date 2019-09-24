MakeWordList <- function(file, csv=F) {
  # Makes the word list from the specified file.
  #
  # Args:
  #   file: The path of the file which is to make the word list.
  #
  # Returns:
  #   The word list.
  
  # Reads from csv file
  if (isTRUE(csv)) {
    x <- read.csv(file)
    # Extracts from column 2 for the end of the row.
    # Because, the first clomun has line number.
    x <- x[, 2:dim(x)[2]]
  } else {
    x <- read.table(file)
  }
  
  N <- dim(x)[1]
  word.list <- list()
  for (i in 1:N) {
    word.list[[i]] <- as.matrix(x[i, !is.na(x[i, ])])
    miss.exist <- sum(word.list[[i]]!="-9")
    if (miss.exist == 0) {
      word.list[[i]] <- NA
    }
  }
  word.list <- word.list[!is.na(word.list)]  
  
  return(word.list)
}
