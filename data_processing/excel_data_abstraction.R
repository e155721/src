# load openxlsx
library(openxlsx)

# output sheets
for (i in 6:135) {
  sheet_num <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheet_num)[,12:27]
  write.table(sheet, paste("sheet-", sheet_num, sep = ""))
}

read.xlsx("テスト用数値一覧・配点表RK_琉球全体72語20180314.xlsm",sheet="01-003首(1-2)")


for (i in 6:135) {
  sheet_num <- i
  sheet <- read.xlsx("テスト用数値一覧・配点表RK_琉球全体72語20180314.xlsm", sheet = sheet_num)[,1:27]
  write.table(sheet, paste("sheet-", sheet_num, sep = ""))
}
