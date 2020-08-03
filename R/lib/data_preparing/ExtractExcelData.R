# load libraries
library(openxlsx)
library(data.table)

source("parallel_config.R")

format_name <- function(name) {
  name <- gsub("*[ ]*", "", name)
  name <- gsub("（", "(", name)
  name <- gsub("）", ")", name)
  return(name)
}

# format_data
format_data <- function(sheet) {
  # except the distinctive features
  sheet <- sheet[, 1:27]
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

input_file <- "../../Data/fix_test_data.xlsm"

# ExcelDataExtraction
ExtractExcelData <- function(input_file=NA, output_dir=NA, csv=F) {

  if (is.na(input_file) || is.na(output_dir)) {
    print("It must be selected that the name of the input directory and the output directory.")
    return(1)
  } else {
    output_dir <- paste(output_dir, "/", sep = "")
  }

  if (!dir.exists(output_dir)) {
    dir.create(output_dir)
  }

  # get the all sheet names
  sheet_names <- getSheetNames(input_file)
  sheet_names_length <- length(sheet_names)
  for (i in 1:sheet_names_length) {
    sheet_names[[i]] <- format_name(sheet_names[[i]])
  }

  # output sheets
  # Use "for" sentence if we get some errors.
  foreach (i = 6:sheet_names_length) %dopar% {
    sheet <- read.xlsx(input_file, sheet = i)
    sheet <- format_data(sheet)
    if (csv) {
      write.csv(sheet, paste(output_dir, sheet_names[i], ".csv", sep = ""), fileEncoding = "utf-8")
    } else {
      write.table(sheet, paste(output_dir, sheet_names[i], ".org", sep = ""), fileEncoding = "utf-8")
    }
  }

  return(0)
}

ExtractExcelData(input_file = "../../Data/fix_test_data.xlsm",
                 output_dir = "../../Alignment/org_data/", csv = F)
