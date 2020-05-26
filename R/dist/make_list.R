# load libraries
library(openxlsx)
library(data.table)

source("lib/load_data_processing.R")
source("lib/data_processing/data_preparing/ExtractExcelData.R")
source("dist/tools/get_regions.R")

FixConcepts <- function(sheet_names) {
  # To add a missed concept for the 51st.
  
  # get the all sheet names
  sheet_names_length <- length(sheet_names)
  
  concepts <- sheet_names[6:length(sheet_names)]
  concepts <- gsub("*[ ]*", "", concepts)
  concepts <- gsub("（", "(", concepts)
  concepts <- gsub("）", ")", concepts)
  concepts <- unique(gsub(pattern = "\\(.*", replacement = "", x = concepts))
  
  A <- concepts[1:50]
  B <- concepts[51:length(concepts)]
  
  A <- c(A, "51")
  concepts <- c(A, B)
  concepts
}

FindSheetName <- function(i, sheet_names) {
  
  if (i < 10) {
    num <- paste("0", i, sep = "")
  } else {
    num <- i
  }
  
  sheet_names[grep(paste(num, "-", sep = ""), sheet_names)]
  
}

# ExcelDataExtraction
input_path = "../../Data/fix_test_data.xlsm"

# get the all sheet names
sheet_names <- getSheetNames(input_path)

all.list <- list()
for (r in 1:95) {
  all.list[[r]] <- list()
  for (c in 1:72) {
    all.list[[r]][[c]] <- list()
  }
}

concepts <- FixConcepts(sheet_names)

names(all.list) <- regions
for (j in 1:72) {
  names(all.list[[j]]) <- concepts
}

for (c in 1:72) {
  
  if (c == 51) {
    # NOP
  } else {
    
    name.vec <- FindSheetName(c, sheet_names)
    N <- length(name.vec)
    
    data.list <- list()
    for (i in 1:N) {
      data.list[[i]] <- FormatData(read.xlsx(input_path, name.vec[i])[, 1:27])
    }
    
    for (r in 1:95) {
      # START
      for (i in 1:N) {
        word <- data.list[[i]][r, ]
        word <- t(as.matrix(word[!is.na(word)]))
        if (sum(word == "-9")) {
          all.list[[r]][[c]][[i]] <- "-9"
        } else {
          all.list[[r]][[c]][[i]] <- DelGap(word)
        }
      }
      
      for (i in N:1) {
        word <- all.list[[r]][[c]][[i]]
        if (word == "-9") {
          all.list[[r]][[c]] <- all.list[[r]][[c]][-i]
        }
      }
      # END
    }
    
  }
}

save(all.list, file = "all_list.RData")
