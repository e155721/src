GetPathList <- function(inputDir = "../../Alignment/input_data/",
                         correctDir = "../../Alignment/correct_data/")
{
  # input files
  inputFiles <- list.files(inputDir)
  inputPaths <- paste(inputDir, inputFiles, sep = "/")
  
  # correct files
  correctFiles <- list.files(correctDir)
  correctPaths <- paste(correctDir, correctFiles, sep = "/")
  
  # make the list of file paths
  pathList <- list()
  numOfFiles <- length(inputFiles)
  for (i in 1:numOfFiles) {
    pathList[[i]] <- c(NA, NA, NA)
    names(pathList[[i]]) <- c("input", "correct", "name")

    pathList[[i]]["input"] <- inputPaths[[i]]
    pathList[[i]]["correct"] <- correctPaths[[i]]
    pathList[[i]]["name"] <- inputFiles[[i]]
  }
  
  return(pathList)
}
