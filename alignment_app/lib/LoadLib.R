LoadLib <- function(path) {
  lib.path <- paste(getwd(), path, sep = "/")
  files <- list.files(lib.path, pattern = "*.R")
  
  for (f in files) {
    print(f)
    source(paste(lib.path, f, sep = ""))
  }
  
  return(0)
}
