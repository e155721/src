# load libraries
library(openxlsx)
library(data.table)

library(foreach)
library(doParallel)
registerDoParallel(detectCores())

# FormatData
FormatData <- function(sheet)
{
  # delete the labels and the assumed form
  sheet <- sheet[-1:-2, ]
  # redundant region
  sheet <- sheet[, -1:-2]
  # redundant some information
  sheet <- sheet[, -2:-9]
  
  dim <- dim(sheet)
  x <- matrix(NA, dim[1], dim[2])
  
  #** region name symbols become numeric if gsub() contains rows of sheet
  #** region name symbols must be used as elements of a vector
  for (j in 1:dim[2]) {
    x[, j] <- as.vector(sheet[, j])
    x[, j] <- gsub("-1", "-", x[, j])
    x[, j] <- gsub("\\.", NA, x[, j])
  }
  
  # all of row elements are changed "-9" if the row has "-9"
  for (i in 1:dim[1]) {
    if (x[i, 2] == "-9")
      x[i, ] <- "-9"
  } 
  
  return(x)
}

# ExcelDataExtraction
ExtractExcelData <- function(input_path = "../../Data/fix_test_data.xlsm",
                             output_path = "../../Alignment/org_data/")
{
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  # get the all sheet names
  sheet_names <- getSheetNames(input_path)
  sheet_names_length <- length(sheet_names)
  for (i in 1:sheet_names_length) {
    sheet_names[[i]] <- gsub("*[ ]*", "", sheet_names[[i]])
    sheet_names[[i]] <- gsub("（", "(", sheet_names[[i]])
    sheet_names[[i]] <- gsub("）", ")", sheet_names[[i]])
  }
  
  # output sheets
  k <- 1
  foreach (i = 6:135) %dopar% {
    sheet <- read.xlsx(input_path, sheet = i)[, 1:27]
    
    #sheet <- transform(sheet, Regions = regions)
    #setcolorder(sheet, "Regions")
    sheet <- FormatData(sheet)
    
    # Writes to csv file.
    write.csv(sheet, paste(output_path, sheet_names[i], ".csv", sep = ""))
    #write.table(sheet, paste(output_path, sheet_names[i], ".org", sep = ""))
    
    # write.table(sheet, paste(output_path, formatC(k, width = 3, flag = 0), ".org", sep = ""))
    k <- k + 1
  }
  
  return(0)
}

ExtractExcelData()
