# data 
library(openxlsx)
for (i in 6:6) {
  #for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}

# load words data
sheet <- read.table("sheet-6.txt", sep = " ")
sheet <- as.matrix(sheet)

row <- dim(sheet)[1]
word_list <- list()
for (i in 1:row) {
  tmp <- sheet[i,]
  word_list[[i]] <- tmp[!is.na(tmp)]
}

for (i in 6:6) {
  #for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}

# load words data
sheet <- read.table("a", sep = " ")
sheet <- as.matrix(sheet)

row <- dim(sheet)[1]
word_list <- list()
for (i in 1:row) {
  tmp <- sheet[i,]
  word_list[[i]] <- tmp[!is.na(tmp)]
}
