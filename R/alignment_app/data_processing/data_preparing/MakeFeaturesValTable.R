source("data_processing/MakeWordList.R")

MakeFeaturesValTable <- function(input_path = "../../Data/test_data.xlsm",
                                    output_path = "features/")
{
  if (!dir.exists(output_path)) {
    dir.create(output_path)
  }
  
  # output vowel sheet
  i <- 2
  vName <- "vowels_values"
  sheet <- read.xlsx(input_path, sheet = i)[ 1:37, 3:7]
  write.table(sheet, 
              paste(output_path, vName, sep = "/"),
              row.names = F,
              col.names = F)
  
  # output consonant sheet
  i <- 4
  cName <- "consonants_values"
  sheet <- read.xlsx(input_path, sheet = i)[1:81, 3:7]
  write.table(sheet, 
              paste(output_path, cName, sep = "/"),
              row.names = F,
              col.names = F)
  
  return(0)
}

MakeFeaturesValTable()
