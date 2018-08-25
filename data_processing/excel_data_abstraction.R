# load openxlsx
library(openxlsx)

# output sheets
for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}