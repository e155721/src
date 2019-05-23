MakeWordList <- function(file)
{
  x <- read.table(file)
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
