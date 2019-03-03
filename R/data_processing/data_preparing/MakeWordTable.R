# load libraries
library(openxlsx)

MakeWordTable <- function(input_path = "../../Data/fix_test_data.xlsm")
{
  sheet_names <- getSheetNames(input_path)
  sheet_names <- sheet_names[-1:-5]
  len <- length(sheet_names)
  sheet_num <- formatC(1:len, width = 3, flag = 0)
  
  for (i in 1:len) {
    sheet_names[[i]] <- gsub("*[ ]*", "", sheet_names[[i]])
  }
  
  write(sheet_num, "gpu_name")
  write(sheet_names, "org_name")
  
  return(0)
}

MakeWordTable()
