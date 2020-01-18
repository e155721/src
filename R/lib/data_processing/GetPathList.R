GetPathList <- function(dir = "../../Alignment/org_data/") {
  # Gets the files path list from a specified directory.
  # 
  # Args:
  #  dir: A character string which the path of the directory you want to get the path of files.
  # 
  # Returns:
  #  The list of path of files.
  
  input.files <- list.files(dir)
  input.paths <- paste(dir, input.files, sep = "/")
  
  # make the list of file paths
  path.list <- list()
  num.files <- length(input.files)
  for (i in 1:num.files) {
    path.list[[i]]          <- c(NA, NA, NA)
    names(path.list[[i]])   <- c("id", "input", "name")
    path.list[[i]]["id"]    <- i
    path.list[[i]]["input"] <- input.paths[[i]]
    path.list[[i]]["name"]  <- input.files[[i]]
  }
  
  return(path.list)
}
