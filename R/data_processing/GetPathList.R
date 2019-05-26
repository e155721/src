GetPathList <- function(inputDir = "../../Alignment/org_data/")
{
  # input files
  inputFiles <- list.files(inputDir)
  inputPaths <- paste(inputDir, inputFiles, sep = "/")
  
  # make the list of file paths
  pathList <- list()
  numOfFiles <- length(inputFiles)
  for (i in 1:numOfFiles) {
    pathList[[i]] <- c(NA)
    names(pathList[[i]]) <- c("input")
    pathList[[i]]["input"] <- inputPaths[[i]]
  }
  
  return(pathList)
}
