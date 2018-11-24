.myfunc.env <- new.env()
sys.source("data_processing/MakeWordList.R", envir = .myfunc.env)
attach(.myfunc.env)

excelFeatureAbstraction <- function(input_path = "../Data/test_data.xlsm",
                                    output_path = "../Feature_Data/feature/")
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
  
  # output vowel sheet
  i <- 2
  sheet <- read.xlsx(input_path, sheet = i)[ 1:37, 3:7]
  write.table(sheet, 
              paste(output_path, sheet_names[i], sep = "/"),
              row.names = F,
              col.names = F)
  
  # output consonant sheet
  i <- 4
  sheet <- read.xlsx(input_path, sheet = i)[1:81, 3:7]
  write.table(sheet, 
              paste(output_path, sheet_names[i], sep = "/"),
              row.names = F,
              col.names = F)
}
