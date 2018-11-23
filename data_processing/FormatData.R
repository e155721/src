# FormatData
FormatData <- function(sheet)
{
  # delete the labels and the assumed form
  sheet <- sheet[-1:-2, ]
  
  dim <- dim(sheet)
  x <- matrix(NA, dim[1], dim[2])
  
  #** region name symbols become numeric if gsub() contains rows of sheet
  #** region name symbols must be used as elements of a vector
  for (j in 1:dim[2]) {
    x[, j] <- as.vector(sheet[, j])
    x[, j] <- gsub("-1", "-", x[, j])
    x[, j] <- gsub("\\.", NA, x[, j])
  }
  
  for (i in 1:dim[1]) {
    if (x[i, 2] == "-9")
      x[i, ] <- NA
  } 
  
  return(x)
}
