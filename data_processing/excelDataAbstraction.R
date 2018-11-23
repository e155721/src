# load openxlsx
library(openxlsx)

# FormatData
FormatData <- function(sheet)
{
  # delete the labels and the assumed form
  sheet <- sheet[-1:-2, ]
  
  dim <- dim(sheet)
  x <- matrix(NA, dim[1], dim[2])
  
  for (j in 1:dim[2]) {
    dots <- sum(sheet[, j] == ".")
    if (dots != 0) break
    x[, j] <- as.vector(sheet[, j])
  }
  
  for (i in 1:dim[1]) {
    if(x[i, 1] == -9) {
      x[i, ] <- NA
    } else {
      x[i, ] <- gsub("-1", "-", x[i, ] )
    }
  }
  
  return(x)
}


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
  
  # output sheets
  # for (i in 6:135) {
  for (i in 6:6) {
    sheet <- read.xlsx(input_path, sheet = i)[, 12:27]
    sheet <- FormatData(sheet)
    write.table(sheet, paste(output_path, sheet_names[i], ".org", sep = ""))
  }
}
