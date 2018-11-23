# FormatData
FormatData <- function(sheet)
{
  # delete the labels and the assumed form
  sheet <- sheet[-1:-2, ]
  
  dim <- dim(sheet)
  x <- matrix(NA, dim[1], dim[2])
  
  charLen <- 0
  for (j in 1:dim[2]) {
    dots <- sum(sheet[, j] == ".")
    if (dots != 0) break
    charLen <- charLen + 1
    x[, j] <- as.vector(sheet[, j])
  }
  
  for (i in 1:dim[1]) {
    if(x[i, 1] == -9) {
      x[i, ] <- NA
    } else {
      x[i, ] <- gsub("-1", "-", x[i, ] )
    }
  }
  
  # remove NA calumns
  x <- x[, -(charLen+1):-dim[2]]
  
  return(x)
}