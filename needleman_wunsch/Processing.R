# data 
library(openxlsx)

# output sheets
for (i in 6:6) {
  #for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}

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

word_list <-  makeWordList("sheet-6.txt")
