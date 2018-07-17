# make scoring matrix for alphabets
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

write.table(scoringMatrix, "scoring_matrix_for_alphabets.txt")

# data 
library(openxlsx)
for (i in 6:6) {
#for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  sheet <- as.matrix(sheet)
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}

