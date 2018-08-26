# load openxlsx
library(openxlsx)

# output sheets
for (i in 6:135) {
  sheet_num <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheet_num)[,12:27]
  write.table(sheet, paste("sheet-", sheet_num, sep = ""))
}