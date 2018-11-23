.myfunc.env = new.env()
sys.source("data_processing/FormatData.R", envir = .myfunc.env)
attach(.myfunc.env)

# load openxlsx
library(openxlsx)

# excelDataAbstraction
excelDataAbstraction <- function(input_path = "../Data/fix_test_data.xlsm",
                                 output_path = "../Alignment/org_data/")
{
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  # get the all sheet names
  sheet_names <- getSheetNames(input_path)
  sheet_names_length <- length(sheet_names)
  for (i in 1:sheet_names_length) {
    sheet_names[i] <- gsub(" ", "", sheet_names[i])
  }
  
  # get the name symbols for each region
  regions <- read.xlsx(input_path, sheet = i)[, 2]
  
  # output sheets
  # for (i in 6:135) {
  for (i in 6:6) {
    sheet <- read.xlsx(input_path, sheet = i)[, 12:27]
    sheet <- transform(sheet, Regions = regions)
    setcolorder(sheet, "Regions")
    sheet <- FormatData(sheet)
    write.table(sheet, paste(output_path, sheet_names[i], ".org", sep = ""))
  }
}
