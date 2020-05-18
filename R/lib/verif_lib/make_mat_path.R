MakeMatPath <- function(rdata1, rdata2, ext) {
  
  if (is.na(ext)) {
    ext <- NULL
  } else {
    ext <- paste("_", ext, sep = "")
  }
  
  path         <- list()
  path$rdata1 <- paste("../../Alignment/", rdata1, ext, "_", format(Sys.Date()), ".RData", sep = "")
  path$rdata2 <- paste("../../Alignment/", rdata2, ext, "_", format(Sys.Date()), ".RData", sep = "")
  
  return(path)
}
