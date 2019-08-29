# load the library.
library(openxlsx)
# load the function.
source("data_processing/MakeWordList.R")

MakeFeaturesValTable <- function(input.path = "../../Data/test_data.xlsm", output.path = "features/") {
  # makes the table of the phoneme feature values which each phonetic symbol has.
  #
  # Args:
  #   input.path: The path of the directory which is to make the table of the phoneme feature values table.
  #   output.path: The path of the directory which the table is outputed.
  #
  # Returns:
  # The exit status.
  if (!dir.exists(output.path)) {
    dir.create(output.path)
  }
  
  # output vowel sheet
  i <- 2
  v.name <- "vowels_values"
  sheet <- read.xlsx(input.path, sheet = i)[ 1:37, 3:7]
  write.table(sheet, 
              paste(output.path, v.name, sep = "/"),
              row.names = F,
              col.names = F)
  
  # output consonant sheet
  i <- 4
  c.name <- "consonants_values"
  sheet <- read.xlsx(input.path, sheet = i)[1:81, 3:7]
  write.table(sheet, 
              paste(output.path, c.name, sep = "/"),
              row.names = F,
              col.names = F)
  
  return(0)
}
