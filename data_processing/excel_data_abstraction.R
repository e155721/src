# load openxlsx
library(openxlsx)

input_path <- "/Users/e155721/OkazakiLab/Data/test_data.xlsm"
output_path <- "/Users/e155721/OkazakiLab/src/org-data/"

# get the all sheet names
sheet_names <- getSheetNames(input_path)

# output sheets
for (i in 6:135) {
  sheet <- read.xlsx(input_path, sheet = i)[,12:27]
  write.table(sheet, paste(output_path, sheet_names[i], sep = "/"))
}