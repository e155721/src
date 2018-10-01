excelFeatureAbstraction <- function(input_path = "../Data/test_data.xlsm",
                                    output_path = "../Alignment/feature/")
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
  for (i in 6:135) {
    sheet <- read.xlsx(input_path, sheet = i)[,28:107]
    write.table(sheet[-1, ], 
                paste(output_path, sheet_names[i], sep = "/"),
                row.names = F,
                col.names = F)
  }
}