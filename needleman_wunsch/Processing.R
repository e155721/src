
# make scoring matrix for alphabets
dimnames <- c(LETTERS)
scoringMatrix <- matrix(-1, nrow = 26, ncol = 26,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

write.table(scoringMatrix, "scoring_matrix_for_alphabets.txt")

##############################################################
dimnames <- c("k", "kx", "kh", "u", "b", "p", "d", "i", "i:")
len <- length(dimnames)
scoringMatrix <- matrix(-10, nrow = len, ncol = len,
                        dimnames = list(dimnames, dimnames))
diag(scoringMatrix) <- 3

p <- -2

# data 
library(openxlsx)
for (i in 6:6) {
  #for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}

# load words data
sheet <- read.table("sheet-6.txt", sep = " ")
sheet <- as.matrix(sheet)

row <- dim(sheet)[1]
word_list <- list()
for (i in 1:row) {
  tmp <- sheet[i,]
  word_list[[i]] <- tmp[!is.na(tmp)]
}

for (i in 6:6) {
  #for (i in 6:135) {
  sheetNum <- i
  sheet <- read.xlsx("test.xlsm", sheet = sheetNum)[,12:27]
  write.table(sheet, paste("sheet-", sheetNum, sep = ""))
}
